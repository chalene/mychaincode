#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

Feature: FAB-5384 Chaincode Testing: As a user I want to be able verify that I can execute different chaincodes

@daily
Scenario: FAB-4703: FAB-5663, Test chaincode calling chaincode - fabric/examples/chaincode_example04
  Given I have a bootstrapped fabric network of type kafka
  When a user sets up a channel
  And a user deploys chaincode at path "github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example04" with args ["init","Event","1"] with name "myex04"
  When a user sets up a channel named "channel2"
  And a user deploys chaincode at path "github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02" with args ["init","a","1000","b","2000"] with name "myex02_a" on channel "channel2"
  When a user queries on the channel "channel2" using chaincode named "myex02_a" with args ["query","a"]
  Then a user receives a success response of 1000
  When a user queries on the chaincode named "myex04" with args ["query","Event", "myex02_a", "a", "channel2"]
  Then a user receives a success response of 1000