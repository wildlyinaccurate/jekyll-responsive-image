Feature: Save to source
  Scenario: Save to source
    Given I have a responsive_image configuration with:
      """
        save_to_source: true
        sizes:
          - width: 100
        extra_images:
          - assets/everybody-loves-jalapeño-pineapple-cornbread.png
          - assets/*.jpeg
      """
    And I have a file "index.html" with "Hello, world!"
    When I run Jekyll
    And the file "assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should exist
    And the file "assets/resized/progressive-100x50.jpeg" should exist
    And the file "_site/assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should exist
    And the file "_site/assets/resized/progressive-100x50.jpeg" should exist

  Scenario: Do not save to source
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
    And the file "assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should not exist
    And the file "assets/resized/progressive-100x50.jpeg" should not exist
    And the file "_site/assets/resized/everybody-loves-jalapeño-pineapple-cornbread-100x50.png" should exist
    And the file "_site/assets/resized/progressive-100x50.jpeg" should exist