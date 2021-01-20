@1
Feature: Testing flight booking

Background:
	# Given I search for 
	# 	| type 	 | destination | checkin 	| checkout_date | adults | children |
	# 	| Hotels | Munich      | 23/01/2021 | 25/01/2021    | 2      | 0        |
	Given I visit something

Scenario: 
	# Then I should see the "hotels" page
	Given I visit something
