Feature: Save to source
  Scenario: Resized images are saved to the source directory by default
    Given I have a responsive_image configuration with:
      """
        sizes:
          - width: 100
        extra_images:
          - assets/everybody-loves-jalapeño-pineapple-cornbread.png
      """
    And I have a file "index.html" with "Hello, world!"
    When I run Jekyll
    Then the file "assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should exist
    And the file "_site/assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should exist

  Scenario: Resized images can be saved to the destination directory only with save_to_source: false
    Given I have a responsive_image configuration with:
      """
        save_to_source: false
        sizes:
          - width: 100
        extra_images:
          - assets/everybody-loves-jalapeño-pineapple-cornbread.png
          - assets/*.jpeg
      """
    And I have a file "index.html" with "Hello, world!"
    When I run Jekyll
    Then the file "assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should not exist
    But the file "_site/assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should exist
