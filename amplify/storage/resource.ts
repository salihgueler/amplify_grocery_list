import { defineStorage } from "@aws-amplify/backend";

const AMPLIFY_GEN_1_ENV_NAME = process.env.AMPLIFY_GEN_1_ENV_NAME ?? "sandbox";

export const storage = defineStorage({ name: `amplifygrocerylist0b3d71909d424d2da80b711e1e61d43bbe-${AMPLIFY_GEN_1_ENV_NAME}`, access: allow => ({
        "public/*": [allow.guest.to(["write", "read", "delete"]), allow.authenticated.to(["write", "read", "delete"])],
        "protected/{entity_id}/*": [allow.authenticated.to(["write", "read", "delete"])],
        "private/{entity_id}/*": [allow.authenticated.to(["write", "read", "delete"])]
    }) });
