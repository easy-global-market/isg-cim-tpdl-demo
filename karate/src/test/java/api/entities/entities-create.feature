@entities
Feature: Test implementation of POST /entities (6.4.3.1)

Background:
  * url urlBase
  * def buildings = read('classpath:samples/buildings.json')
  * def buildingMinimal = read('classpath:samples/building-minimal.jsonld')
  * def building = read('classpath:samples/building.jsonld')
  * def buildingWithoutContext = read('classpath:samples/building-without-context.json')
  * configure charset = null

Scenario Outline: Create Buildings with different payloads
    Given path 'entities'
    And request __row
    And header Content-Type = 'application/ld+json'
    When method post
    Then status 201
Examples:
    | buildings |

Scenario: Create Building with unsupported Media type
    Given path 'entities'
    And request building
    And header Content-Type = 'application/unkwnown'
    When method post
    Then status 415

Scenario: Create Building with wrong Media type (application/json with JSON-LD payload)
    Given path 'entities'
    And request building
    And header Content-Type = 'application/json'
    When method post
    Then status 400
    And match response.detail == 'Request payload must not contain @context term for a request having an application/json content type'

Scenario: Create Building with wrong Media type (application/ld+json with JSON-LD Link header)
    Given path 'entities'
    And request building
    And header Content-Type = 'application/ld+json'
    And header Link = '<https://fiware.github.io/data-models/context.jsonld>; rel=http://www.w3.org/ns/json-ld#context; type=application/ld+json'
    When method post
    Then status 400
    And match response.detail == 'JSON-LD Link header must not be provided for a request having an application/ld+json content type'

Scenario: Create Building with wrong Media type (application/ld+json without @context in the payload)
    Given path 'entities'
    And request buildingWithoutContext
    And header Content-Type = 'application/ld+json'
    When method post
    Then status 400
    And match response.detail == 'Request payload must contain @context term for a request having an application/ld+json content type'

Scenario: Create already created Building
    Given path 'entities'
    And request buildingMinimal
    And header Content-Type = 'application/ld+json'
    When method post
    Then status 409