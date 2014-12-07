Feature: Jekyll responsive_image_block tag
  As a Jekyll template developer
  I want to include Liquid variables when rendering my responsive images
  In order to dynamically generate my responsive images

  Scenario: Simple image tag
    Given I have a responsive_image configuration with "template" set to "_includes/responsive-image.html"
    And I have a file "index.html" with:
      """
      {% assign path = 'assets/test.png' %}
      {% assign alt = 'Lorem ipsum' %}

      {% responsive_image_block %}
          path: {{ path }}
          title: Magic rainbow adventure!
          alt: {{ alt }}
      {% endresponsive_image_block %}
      """
    When I run Jekyll
    Then I should see "<img alt=\"Lorem ipsum\" src=\"/assets/test.png\" title=\"Magic rainbow adventure!\"" in "_site/index.html"

  Scenario: More complex logic in the block tag
    Given I have a responsive_image configuration with "template" set to "_includes/responsive-image.html"
    And I have a file "index.html" with:
      """
      {% assign path = 'assets/test.png' %}
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
    Then I should see "<img alt=\"Lorem ipsum\" src=\"/assets/test.png\"" in "_site/index.html"
