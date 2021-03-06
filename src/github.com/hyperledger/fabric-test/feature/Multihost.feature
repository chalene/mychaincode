# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#


Feature: Peer Service
    As a user I want to be able have channels and chaincodes to execute


@daily
@simple
Scenario Outline: FAB-3865: Multiple Channels Per Peer, with <type> orderer
    Given I have a bootstrapped fabric network of type <type>
    When a user sets up a channel named "chn1"
    And a user deploys chaincode at path "github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02" with args ["init", "a", "1000" , "b", "2000"] with name "cc1" on channel "chn1"
    When a user sets up a channel named "chn2"
    And a user deploys chaincode at path "github.com/hyperledger/fabric/examples/chaincode/go/map" with args ["init"] with name "cc2" on channel "chn2"
    When a user invokes on the channel "chn2" using chaincode named "cc2" with args ["put", "a", "1000"]
    And I wait "5" seconds
    And a user queries on the channel "chn2" using chaincode named "cc2" with args ["get", "a"]
    # the "map" chaincode adds quotes around the result
    Then a user receives a success response of "1000"
    When a user invokes on the channel "chn2" using chaincode named "cc2" with args ["put", "b", "2000"]
    And I wait "5" seconds
    And a user queries on the channel "chn2" using chaincode named "cc2" with args ["get", "b"]
    # the "map" chaincode adds quotes around the result
    Then a user receives a success response of "2000"
    When a user invokes on the channel "chn1" using chaincode named "cc1" with args ["invoke", "a", "b", "10"]
    And I wait "5" seconds
    And a user queries on the channel "chn1" using chaincode named "cc1" with args ["query", "a"]
    Then a user receives a success response of 990
    When a user queries on the channel "chn2" using chaincode named "cc2" with args ["get", "a"]
    # the "map" chaincode adds quotes around the result
    Then a user receives a success response of 1000
Examples:
    | type  |
    | solo  |
    | kafka |


@daily
Scenario Outline: FAB-3866: Multiple Chaincodes Per Peer, with <type> orderer
    Given I have a bootstrapped fabric network of type <type>
    When a user sets up a channel
    And a user deploys chaincode at path "github.com/hyperledger/fabric/examples/chaincode/go/eventsender" with args [] with name "eventsender"
    When a user invokes on the chaincode named "eventsender" with args ["invoke", "test_event"]
    And I wait "5" seconds
    And a user queries on the chaincode named "eventsender" with args ["query"]
    Then a user receives a success response of {"NoEvents":"1"}
    When a user deploys chaincode at path "github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02" with args ["init", "a", "1000" , "b", "2000"] with name "example02"
    When a user invokes on the chaincode named "example02" with args ["invoke", "a", "b", "10"]
    And I wait "5" seconds
    And a user queries on the chaincode named "example02" with args ["query", "a"]
    Then a user receives a success response of 990
    When a user deploys chaincode at path "github.com/hyperledger/fabric/examples/chaincode/go/map" with args ["init"] with name "map"
    When a user invokes on the chaincode named "map" with args ["put", "a", "1000"]
    And I wait "5" seconds
    And a user queries on the chaincode named "map" with args ["get", "a"]
    # the "map" chaincode adds quotes around the result
    Then a user receives a success response of "1000"
    When a user deploys chaincode at path "github.com/hyperledger/fabric/examples/chaincode/go/marbles02" with args [] with name "marbles"
    When a user invokes on the chaincode named "marbles" with args ["initMarble", "marble1", "blue", "35", "tom"]
    And I wait "5" seconds
    And a user invokes on the chaincode named "marbles" with args ["transferMarble", "marble1", "jerry"]
    And I wait "5" seconds
    And a user queries on the chaincode named "marbles" with args ["readMarble", "marble1"]
    Then a user receives a success response of {"docType":"marble","name":"marble1","color":"blue","size":35,"owner":"jerry"}
    When a user deploys chaincode at path "github.com/hyperledger/fabric/examples/chaincode/go/sleeper" with args ["1"] with name "sleeper"
    When a user invokes on the chaincode named "sleeper" with args ["put", "a", "1000", "1"]
    And I wait "5" seconds
    And a user queries on the chaincode named "sleeper" with args ["get", "a", "1"]
    Then a user receives a success response of 1000
Examples:
    | type  |
    | solo  |
    | kafka |
