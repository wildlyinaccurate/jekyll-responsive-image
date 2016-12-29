Feature: Jekyll responsive_image tag
  As a Jekyll template developer
  I want to include responsive images in my page

  Scenario: Simple image tag
    Given I have a responsive_image configuration with "template" set to "_includes/responsive-image.html"
    And I have a file "index.html" with "{% responsive_image path: assets/everybody-loves-jalapeño-pineapple-cornbread.png alt: Foobar %}"
    When I run Jekyll
    Then I should see "<img alt=\"Foobar\" src=\"/assets/everybody-loves-jalapeño-pineapple-cornbread.png\"" in "_site/index.html"

  Scenario: Global variables available in templates
    Given I have a file "index.html" with "{% responsive_image path: assets/everybody-loves-jalapeño-pineapple-cornbread.png %}"
    And I have a configuration with:
      """
        baseurl: https://wildlyinaccurate.com
        responsive_image:
          template: _includes/base-url.html
      """
    When I run Jekyll
    Then I should see "<img src=\"https://wildlyinaccurate.com/assets/everybody-loves-jalapeño-pineapple-cornbread.png\">" in "_site/index.html"

  Scenario: Adding custom attributes
    Given I have a responsive_image configuration with "template" set to "_includes/responsive-image.html"
    And I have a file "index.html" with:
      """
      {% responsive_image path: assets/everybody-loves-jalapeño-pineapple-cornbread.png alt: 'Foobar bazbar' title: "Lorem Ipsum" %}
      """
    When I run Jekyll
    Then I should see "<img alt=\"Foobar bazbar\" src=\"/assets/everybody-loves-jalapeño-pineapple-cornbread.png\" title=\"Lorem Ipsum\"" in "_site/index.html"

  Scenario: UTF-8 attributes
    Given I have a responsive_image configuration with "template" set to "_includes/responsive-image.html"
    And I have a file "index.html" with "{% responsive_image path: assets/everybody-loves-jalapeño-pineapple-cornbread.png alt: 'かっこいい！ ジェケルが好きです！' %}"
    When I run Jekyll
    Then I should see "<img alt=\"かっこいい！ ジェケルが好きです！\" src=\"/assets/everybody-loves-jalapeño-pineapple-cornbread.png\"" in "_site/index.html"

  Scenario: Image with multiple sizes
    Given I have a responsive_image configuration with:
      """
        template: _includes/responsive-image.html
        sizes:
          - width: 100
          - width: 200
      """
    And I have a file "index.html" with "{% responsive_image path: assets/subdir/test.png %}"
    When I run Jekyll
    Then I should see "<img alt=\"\" src=\"/assets/subdir/test.png\"" in "_site/index.html"
    And I should see "/assets/resized/test-100x50.png 100w,/assets/resized/test-200x100.png 200w,/assets/subdir/test.png 300w" in "_site/index.html"

  Scenario: Overriding the template
    Given I have a responsive_image configuration with:
      """
        template: _includes/responsive-image.html
        sizes:
          - width: 50
          - width: 100
      """
    And I have a file "index.html" with "{% responsive_image path: assets/everybody-loves-jalapeño-pineapple-cornbread.png template: _includes/custom-template.html %}"
    When I run Jekyll
    Then I should see "[50, 100]" in "_site/index.html"

  Scenario: Overriding the generated filenames
    Given I have a responsive_image configuration with:
      """
        template: _includes/responsive-image.html
        output_path_format: assets/%{dirname}/%{basename}-resized/%{width}/%{filename}-%{height}.%{extension}
        sizes:
          - width: 100
      """
    And I have a file "index.html" with "{% responsive_image path: assets/everybody-loves-jalapeño-pineapple-cornbread.png %}"
    When I run Jekyll
    Then I should see "/assets/everybody-loves-jalapeño-pineapple-cornbread.png-resized/100/everybody-loves-jalapeño-pineapple-cornbread-50.png 100w" in "_site/index.html"
