Feature: Extra image generation
  Scenario: Specifying a single image and glob patterns
    Given I have a responsive_image configuration with:
      """
        sizes:
          - width: 100
        extra_images:
          - assets/everybody-loves-jalapeño-pineapple-cornbread.png
          - assets/*.jpeg
      """
    And I have a file "index.html" with "Hello, world!"
    When I run Jekyll
    Then the image "assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should have the dimensions "100x50"
    And the image "assets/resized/progressive-100x50.jpeg" should have the dimensions "100x50"
    And the file "_site/assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should exist
    And the file "_site/assets/resized/progressive-100x50.jpeg" should exist

  Scenario: Specifying a recursive glob pattern
    Given I have a responsive_image configuration with:
      """
        sizes:
          - width: 100
        extra_images:
          - assets/**/*
      """
    And I have a file "index.html" with "Hello, world!"
    When I run Jekyll
    Then the image "assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should have the dimensions "100x50"
    And the image "assets/resized/exif-rotation-100x50.jpeg" should have the dimensions "100x50"
    And the image "assets/resized/progressive-100x50.jpeg" should have the dimensions "100x50"
    And the image "assets/resized/test-100x50.png" should have the dimensions "100x50"
    And the file "_site/assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should exist
    And the file "_site/assets/resized/exif-rotation-100x50.jpeg" should exist
    And the file "_site/assets/resized/progressive-100x50.jpeg" should exist
    And the file "_site/assets/resized/test-100x50.png" should exist

  Scenario: Honouring Jekyll 'source' configuration
    Given I have copied my site to "sub-dir/my-site-copy"
    And I have a configuration with:
      """
        source: sub-dir/my-site-copy
        responsive_image:
          sizes:
            - width: 100
          extra_images:
            - assets/*.png
      """
    And I have a file "index.html" with "Hello, world!"
    When I run Jekyll
    Then the image "sub-dir/my-site-copy/assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should have the dimensions "100x50"
    And the file "_site/assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should exist
    And the file "_site/assets/resized/progressive-100x50.jpeg" should not exist
