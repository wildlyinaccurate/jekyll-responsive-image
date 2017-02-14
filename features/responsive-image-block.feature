Feature: Jekyll responsive_image_block tag
  As a Jekyll template developer
  I want to include Liquid variables when rendering my responsive images
  In order to dynamically generate my responsive images

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

  Scenario: Handling excerpts
    Given I have a responsive_image configuration with "template" set to "_includes/responsive-image.html"
    And I have a file "_posts/2001-01-01-test-post.md" with:
      """
      {% responsive_image_block %}
          path: assets/everybody-loves-jalapeño-pineapple-cornbread.png
          alt: {{ page.id }}
      {% endresponsive_image_block %}
      """
    And I have a file "index.html" with "{% for post in site.posts %}{{ post.excerpt }}{% endfor %}"
    When I run Jekyll
    Then I should see "<img alt=\"/2001/01/01/test-post\"" in "_site/index.html"

  Scenario: Handling a nil path
    Given I have a responsive_image configuration with "template" set to "_includes/responsive-image.html"
    And I have a file "index.html" with:
      """
      {% responsive_image_block %}
          path: {{ path }}
      {% endresponsive_image_block %}
      """
    Then Jekyll should throw a "SyntaxError"
