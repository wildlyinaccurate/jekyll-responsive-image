Feature: Jekyll responsive_image_block tag
  Scenario: Simple image tag
    Given I have a responsive_image configuration with "template" set to "_includes/responsive-image.html"
    And I have a file "index.html" with:
      """
      {% assign path = 'assets/everybody-loves-jalapeño-pineapple-cornbread.png' %}
      {% responsive_image_block %}
          path: {{ path }}
          title: Magic rainbow adventure!
          alt: Lorem ipsum
      {% endresponsive_image_block %}
      """
    When I run Jekyll
    Then I should see "<img alt=\"Lorem ipsum\" src=\"/assets/everybody-loves-jalapeño-pineapple-cornbread.png\" title=\"Magic rainbow adventure!\"" in "_site/index.html"

  Scenario: Tabs for indentation
    Given I have a responsive_image configuration with "template" set to "_includes/responsive-image.html"
    And I have a file "index.html" with:
      """
      {% assign path = 'assets/everybody-loves-jalapeño-pineapple-cornbread.png' %}
      {% responsive_image_block %}
      	path: {{ path }}
      	title: Magic rainbow adventure!
      	alt: Lorem ipsum
      {% endresponsive_image_block %}
      """
    When I run Jekyll
    Then I should see "<img alt=\"Lorem ipsum\" src=\"/assets/everybody-loves-jalapeño-pineapple-cornbread.png\" title=\"Magic rainbow adventure!\"" in "_site/index.html"

  Scenario: Global variables available in templates
    Given I have a file "index.html" with:
      """
      {% responsive_image_block %}
          path: assets/everybody-loves-jalapeño-pineapple-cornbread.png
      {% endresponsive_image_block %}
      """
    And I have a configuration with:
      """
        baseurl: https://wildlyinaccurate.com
        responsive_image:
          template: _includes/base-url.html
      """
    When I run Jekyll
    Then I should see "<img src=\"https://wildlyinaccurate.com/assets/everybody-loves-jalapeño-pineapple-cornbread.png\">" in "_site/index.html"

  Scenario: More complex logic in the block tag
    Given I have a responsive_image configuration with "template" set to "_includes/responsive-image.html"
    And I have a file "index.html" with:
      """
      {% assign path = 'assets/everybody-loves-jalapeño-pineapple-cornbread.png' %}
      {% assign alt = 'Lorem ipsum' %}
      {% responsive_image_block %}
          path: {{ path }}

          {% if another_alt %}
          alt: {{ another_alt }}
          {% else %}
          alt: {{ alt }}
          {% endif %}
      {% endresponsive_image_block %}
      """
    When I run Jekyll
    Then I should see "<img alt=\"Lorem ipsum\" src=\"/assets/everybody-loves-jalapeño-pineapple-cornbread.png\"" in "_site/index.html"

  Scenario: Handling a nil path
    Given I have a responsive_image configuration with "template" set to "_includes/responsive-image.html"
    And I have a file "index.html" with:
      """
      {% responsive_image_block %}
          path: {{ path }}
      {% endresponsive_image_block %}
      """
    Then Jekyll should throw a "Magick::ImageMagickError"
