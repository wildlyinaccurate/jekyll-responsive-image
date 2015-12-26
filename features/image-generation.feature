Feature: Responsive image generation
  As a Jekyll user
  I want to generate responsive images
  In order to use them on my pages

  Scenario: Resizing images
    Given I have a responsive_image configuration with:
      """
        template: _includes/responsive-image.html
        sizes:
          - width: 100
      """

    And I have a file "index.html" with "{% responsive_image path: assets/test.png alt: Foobar %}"
    When I run Jekyll
    Then the image "assets/resized/test-100x50.png" should have the dimensions "100x50"

  Scenario: Handling subdirectories
    Given I have a responsive_image configuration with:
      """
        template: _includes/responsive-image.html
        output_path_format: "%{dirname}/resized/%{filename}-%{width}.%{extension}"
        sizes:
          - width: 100
      """

    And I have a file "index.html" with:
      """
        {% responsive_image path: assets/test.png %}
        {% responsive_image path: assets/subdir/test.png %}
      """

    When I run Jekyll
    Then the file "assets/resized/test-100.png" should exist
    And the file "assets/subdir/resized/test-100.png" should exist
