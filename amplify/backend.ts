import { RemovalPolicy, Tags } from "aws-cdk-lib";
import { auth } from "./auth/resource";
import { data } from "./data/resource";
import { storage } from "./storage/resource";
import { defineBackend } from "@aws-amplify/backend";
import ci from "ci-info";
import { Duration } from "aws-cdk-lib";
import * as s3 from "aws-cdk-lib/aws-s3";

let AMPLIFY_GEN_1_ENV_NAME = process.env.AMPLIFY_GEN_1_ENV_NAME;
if (ci.isCI && !AMPLIFY_GEN_1_ENV_NAME) {
  throw new Error("AMPLIFY_GEN_1_ENV_NAME is required in CI environment");
} else if (!ci.isCI && !AMPLIFY_GEN_1_ENV_NAME) {
  AMPLIFY_GEN_1_ENV_NAME = "sandbox";
}

const backend = defineBackend({
  auth,
  data,
  storage,
});
const cfnUserPool = backend.auth.resources.cfnResources.cfnUserPool;
cfnUserPool.userPoolName = `amplifygrocerylist11c08749_userpool_11c08749-${AMPLIFY_GEN_1_ENV_NAME}`;
cfnUserPool.usernameAttributes = undefined;
cfnUserPool.policies = {
  passwordPolicy: {
    minimumLength: 8,
    requireLowercase: false,
    requireNumbers: false,
    requireSymbols: false,
    requireUppercase: false,
    temporaryPasswordValidityDays: 7,
  },
};
const cfnIdentityPool = backend.auth.resources.cfnResources.cfnIdentityPool;
cfnIdentityPool.identityPoolName = `amplifygrocerylist11c08749_identitypool_11c08749__${AMPLIFY_GEN_1_ENV_NAME}`;
const userPool = backend.auth.resources.userPool;
const userPoolClient = userPool.addClient("NativeAppClient", {
  disableOAuth: true,
  authSessionValidity: Duration.minutes(3),
  userPoolClientName: "amplif11c08749_app_client",
  enablePropagateAdditionalUserContextData: false,
  enableTokenRevocation: true,
  refreshTokenValidity: Duration.days(30),
  generateSecret: false,
});
const s3Bucket = backend.storage.resources.cfnResources.cfnBucket;
s3Bucket.bucketName = `amplifygrocerylist0b3d71909d424d2da80b711e1e61d43bbe-${AMPLIFY_GEN_1_ENV_NAME}`;
s3Bucket.bucketEncryption = {
  serverSideEncryptionConfiguration: [
    {
      serverSideEncryptionByDefault: {
        sseAlgorithm: "AES256",
      },
      bucketKeyEnabled: false,
    },
  ],
};
Tags.of(backend.stack).add("gen1-migrated-app", "true");
