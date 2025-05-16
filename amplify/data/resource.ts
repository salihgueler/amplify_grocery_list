import { defineData } from "@aws-amplify/backend";

const schema = `type Grocery @model @auth(rules: [{allow: owner}]) {
  id: ID!
  groceryItems: [GroceryItem!]! @hasMany(indexName: "byGrocery", fields: ["id"])
  title: String
  fileKey: String
  finalizationDate: AWSDate
  totalAmount: Float
}

type GroceryItem @model @auth(rules: [{allow: owner}]) {
  id: ID!
  name: String!
  count: Int!
  amount: Float!
  groceryID: ID! @index(name: "byGrocery")
} `;

export const data = defineData({
    migratedAmplifyGen1DynamoDbTableMappings: [{
            // Replace the environment name (dev) with the corresponding branch name. Use "sandbox" for your sandbox environment.
            branchName: "dev",
            /**
            * Unable to find the table mapping for this environment.
            * This could be due the enableGen2Migration feature flag not being set to true for this environment.
            * Please enable the feature flag and push the backend resources.
            * If you are not planning to migrate this environment, you can remove this key.
            */
            modelNameToTableNameMapping: {}
        }, {
            // Replace the environment name (migrate) with the corresponding branch name. Use "sandbox" for your sandbox environment.
            branchName: "migrate",
            modelNameToTableNameMapping: { Grocery: "Grocery-jtr4ivtnfna3jgurvrt2mhzz5m-migrate", GroceryItem: "GroceryItem-jtr4ivtnfna3jgurvrt2mhzz5m-migrate" }
        }],
    schema
});
