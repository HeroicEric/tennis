Feature: Test this application with Cucumber
	In order to keep my code working
	As a developer
	I want to write tests and run them

	Scenario: Hello World
		Given a guest
		When I go to the home page
		Then I should see "Find an Instructor"