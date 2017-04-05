Feature: Image hashes inside responsive image templates
  Scenario: Using the {% responsive_image %} tag
    Given I have copied my site to "my-site-copy/src"
    And I have a configuration with:
      """
        source: my-site-copy/src
        responsive_image:
          template: _includes/hash.html
          output_path_format: assets/resized/%{dirname}/%{width}/%{basename}
          sizes:
            - width: 100
      """
    And I have a file "my-site-copy/src/index.html" with "{% responsive_image path: assets/subdir/test.png %}"
    When I run Jekyll
    Then the file "_site/index.html" should contain:
      """
      path: assets/subdir/test.png
      width: 300
      height: 150
      basename: test.png
      dirname: subdir
      filename: test
      extension: png

      path: assets/resized/subdir/100/test.png
      width: 100
      height: 50
      basename: test.png
      dirname: resized/subdir/100
      filename: test
      extension: png
      """
