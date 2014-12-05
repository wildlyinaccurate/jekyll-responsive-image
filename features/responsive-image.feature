Feature: Jekyll responsive-image tag
  As a Jekyll template developer
  I want to include responsive images in my page
  In order to best cater for devices of all sizes

  Scenario: Simple image tag
    Given I have a responsive_image configuration with:
      """
        template: _includes/responsive-image.html
      """
    And I have a file "index.html" with:
      """
        {% responsive_image path: assets/test.jpg %}
      """
    When I run Jekyll
    Then I should see "<img src=\"/assets/test.jpg\" alt=\"\">" in "_site/index.html"
