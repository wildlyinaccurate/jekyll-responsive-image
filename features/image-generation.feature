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

    And I have a file "index.html" with "{% responsive_image path: assets/everybody-loves-jalapeño-pineapple-cornbread.png alt: Foobar %}"
    When I run Jekyll
    Then the image "assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should have the dimensions "100x50"
    And the file "_site/assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should exist

  Scenario: Handling subdirectories
    Given I have a responsive_image configuration with:
      """
        template: _includes/responsive-image.html
        output_path_format: assets/resized/%{dirname}/%{filename}-%{width}.%{extension}
        sizes:
          - width: 100
      """

    And I have a file "index.html" with:
      """
        {% responsive_image path: assets/everybody-loves-jalapeño-pineapple-cornbread.png %}
        {% responsive_image path: assets/subdir/test.png %}
        {% responsive_image path: assets/everybody-loves-jalapeño-pineapple-cornbread.png cache: true %}
      """

    When I run Jekyll
    Then the file "assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100.png" should exist
    And the file "_site/assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100.png" should exist
    And the file "assets/resized/subdir/test-100.png" should exist
    And the file "_site/assets/resized/subdir/test-100.png" should exist
