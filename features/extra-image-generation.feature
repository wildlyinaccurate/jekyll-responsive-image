Feature: Extra image generation
  As a Jekyll user
  I want to resize images that aren't used in posts or pages
  In order to use them in my stylesheets

  Scenario: Resizing a single image
    Given I have a responsive_image configuration with:
      """
        sizes:
          - width: 100

        extra_images:
          - assets/everybody-loves-jalapeño-pineapple-cornbread.png
      """

    And I have a file "index.html" with "Hello, world!"
    When I run Jekyll
    Then the image "assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should have the dimensions "100x50"

  Scenario: Using glob patterns
    Given I have a responsive_image configuration with:
      """
        sizes:
          - width: 100

        extra_images:
          - assets/*.png
      """

    And I have a file "index.html" with "Hello, world!"
    When I run Jekyll
    Then the image "assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should have the dimensions "100x50"

  Scenario: No extra images
    Given I have a responsive_image configuration with:
      """
        sizes:
          - width: 100
      """

    And I have a file "index.html" with "Hello, world!"
    When I run Jekyll
    Then the file "assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should not exist
