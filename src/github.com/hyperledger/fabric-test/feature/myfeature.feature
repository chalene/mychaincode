#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

Feature: FAB-5384 Chaincode Testing: As a user I want to be able verify that I can execute different chaincodes

@daily
Scenario Outline: FAB-5797: Test chaincode fabric/examples/chaincode_example02 deploy, invoke, and query with chaincode install name in all lowercase/uppercase/mixedcase chars, for <type> orderer
    Given I have a bootstrapped fabric network of type <type>
    And I wait "<waitTime>" seconds
    When a user sets up a channel
    And a user deploys chaincode at path "github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02" with args ["init","a","1000","b","2000"] with name "<ccName>"
    And I wait "15" seconds
    Then the chaincode is deployed
    When a user queries on the chaincode named "<ccName>" with args ["query","a"]
    Then a user receives a success response of 1000
    When a user invokes on the chaincode named "<ccName>" with args ["invoke","a","b","10"]
    And I wait "3" seconds
    When a user queries on the chaincode named "<ccName>" with args ["query","a"]
    Then a user receives a success response of 990
Examples:
    | type  | waitTime |  ccName   |
    | solo  |     5    |   mycc    |
    # | solo  |     5    |   MYCC    |
    # | solo  |     5    | MYcc_Test |
    # | kafka |    30    |   mycc    |
    # | kafka |    30    |   MYCC    |
    # | kafka |    30    | MYcc_Test |