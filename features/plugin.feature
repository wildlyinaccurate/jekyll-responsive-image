Feature: General plugin usage
  Scenario: No config at all
    Given I have no configuration
    When I run Jekyll
    Then there should be no errors

  Scenario: Config with empty responsive_image block
    Given I have a responsive_image configuration with:
      """
      """
    When I run Jekyll
    Then there should be no errors
