Feature: Responsive image generation
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

  Scenario: Honouring source image interlace mode and rotation
    Given I have a responsive_image configuration with:
      """
        template: _includes/responsive-image.html
        sizes:
          - width: 100
      """
    And I have a file "index.html" with "{% responsive_image path: assets/progressive.jpeg %}"
    When I run Jekyll
    Then the image "assets/resized/progressive-100x50.jpeg" should be interlaced
    And the image "assets/resized/progressive-100x50.jpeg" should be rotated

  Scenario: Honouring Jekyll 'source' configuration
    Given I have copied my site to "my-site-copy/src"
    And I have a configuration with:
      """
        source: my-site-copy/src
        responsive_image:
          base_path: assets
          template: _includes/responsive-image.html
          output_path_format: assets/resized/%{dirname}/%{width}/%{basename}
          sizes:
            - width: 100
      """
    And I have a file "my-site-copy/src/index.html" with "{% responsive_image path: assets/subdir/test.png %}"
    When I run Jekyll
    Then the image "my-site-copy/src/assets/resized/subdir/100/test.png" should have the dimensions "100x50"
    And the file "_site/assets/resized/subdir/100/test.png" should exist

  Scenario: Images can be auto-rotated based on EXIF rotation
    Given I have a responsive_image configuration with:
      """
        template: _includes/responsive-image.html
        sizes:
          - width: 100
        auto_rotate: true
      """
    And I have a file "index.html" with "{% responsive_image path: assets/exif-rotation.jpeg %}"
    When I run Jekyll
    Then the file "_site/assets/resized/exif-rotation-100x200.jpeg" should exist

  Scenario: Images aren't auto-rotated by default
    Given I have a responsive_image configuration with:
      """
        template: _includes/responsive-image.html
        sizes:
          - width: 100
      """
    And I have a file "index.html" with:
      """
        {% responsive_image path: assets/exif-rotation.jpeg %}
        {% responsive_image path: assets/progressive.jpeg %}
      """
    When I run Jekyll
    Then the file "_site/assets/resized/exif-rotation-100x50.jpeg" should exist
    Then the file "_site/assets/resized/progressive-100x50.jpeg" should exist
