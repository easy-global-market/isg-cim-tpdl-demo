@entities
Feature: Test implementation of POST /entities (6.4.3.1) with existing entity
    TP/NGSI-LD/ContextInformation/Provision/Entities/CreateEntity/AlreadyExists

Background:
  * url urlBase
  * def token = accessToken
  * configure headers = read('classpath:headers.js')

  * def fixtures = callonce read('support/create-entity-fixture.feature')
  * def building = read('classpath:ngsi-ld/payloads/entities/building-minimal.jsonld')

  * configure afterScenario =
    """
    function() {
      karate.call('./support/delete-fixture-entity.feature', { uri: 'urn:ngsi-ld:Building:EGM-Office-409' });
    }
    """

Scenario: Check that you cannot create an entity if there is already one with the same identifier
    Given path 'entities'
    And request building
    And header Content-Type = 'application/ld+json'
    When method post
    Then status 409
    And match response.type == 'https://uri.etsi.org/ngsi-ld/errors/AlreadyExists'
    And match response.title == '#notnull'
