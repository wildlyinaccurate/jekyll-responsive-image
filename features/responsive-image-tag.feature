Feature: Jekyll responsive_image tag
  As a Jekyll template developer
  I want to include responsive images in my page
  In order to best cater for devices of all sizes

  Scenario: Simple image tag
    Given I have a responsive_image configuration with "template" set to "_includes/responsive-image.html"
    And I have a file "index.html" with "{% responsive_image path: assets/test.png alt: Foobar %}"
    When I run Jekyll
    Then I should see "<img alt=\"Foobar\" src=\"/assets/test.png\"" in "_site/index.html"

  Scenario: Global variables available in templates
    Given I have a file "index.html" with "{% responsive_image path: assets/test.png %}"
    And I have a configuration with:
      """
        baseurl: https://wildlyinaccurate.com
        responsive_image:
          template: _includes/base-url.html
      """
    When I run Jekyll
    Then I should see "<img src=\"https://wildlyinaccurate.com/assets/test.png\">" in "_site/index.html"

  Scenario: Adding custom attributes
    Given I have a responsive_image configuration with "template" set to "_includes/responsive-image.html"
    And I have a file "index.html" with:
      """
      {% responsive_image path: assets/test.png alt: 'Foobar bazbar' title: "Lorem Ipsum" %}
      """
    When I run Jekyll
    Then I should see "<img alt=\"Foobar bazbar\" src=\"/assets/test.png\" title=\"Lorem Ipsum\"" in "_site/index.html"

  Scenario: UTF-8 attributes
    Given I have a responsive_image configuration with "template" set to "_includes/responsive-image.html"
    And I have a file "index.html" with "{% responsive_image path: assets/test.png alt: 'かっこいい！ ジェケルが好きです！' %}"
    When I run Jekyll
    Then I should see "<img alt=\"かっこいい！ ジェケルが好きです！\" src=\"/assets/test.png\"" in "_site/index.html"

  Scenario: Image with multiple sizes
    Given I have a responsive_image configuration with:
      """
        template: _includes/responsive-image.html
        sizes:
          - width: 100
          - width: 200
      """
    And I have a file "index.html" with "{% responsive_image path: assets/test.png %}"
    When I run Jekyll
    Then I should see "<img alt=\"\" src=\"/assets/test.png\"" in "_site/index.html"
    And I should see "/assets/resized/test-100x50.png 100w" in "_site/index.html"
    And I should see "/assets/resized/test-200x100.png 200w" in "_site/index.html"
    And I should see "/assets/test.png 300w" in "_site/index.html"
    And the file "assets/resized/test-100x50.png" should exist
    And the file "assets/resized/test-200x100.png" should exist

  Scenario: Overriding the template
    Given I have a responsive_image configuration with:
      """
        template: _includes/responsive-image.html
        sizes:
          - width: 100
          - width: 200
          - width: 300
      """
    And I have a file "index.html" with "{% responsive_image path: assets/test.png template: _includes/custom-template.html %}"
    When I run Jekyll
    Then I should see "[100, 200, 300]" in "_site/index.html"

  Scenario: Overriding the generated filenames
    Given I have a responsive_image configuration with:
      """
        template: _includes/responsive-image.html
        output_path_format: assets/%{basename}-resized/%{width}/%{filename}-%{height}.%{extension}
        sizes:
          - width: 100
      """
    And I have a file "index.html" with "{% responsive_image path: assets/test.png %}"
    When I run Jekyll
    Then I should see "/assets/test.png-resized/100/test-50.png 100w" in "_site/index.html"
    And the file "assets/test.png-resized/100/test-50.png" should exist
