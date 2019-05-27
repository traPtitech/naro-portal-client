const request = require("request-promise-native");
const fs = require("fs").promises;
const { promisify } = require("util");
const { exec } = require("child_process");

const URL =
  "https://raw.githubusercontent.com/sapphi-red/webengineer_naro-_7_server/master/swagger.yaml";

const execAsync = promisify(exec);

(async () => {
  const res = await request(URL);

  try {
    await fs.mkdir("./scripts/bin/");
  } catch {}
  await fs.writeFile("./scripts/bin/swagger.yaml", res, "utf-8");

  const { stdout, stderr } = await execAsync(
    "npx openapi-generator generate -g typescript-axios -i ./scripts/bin/swagger.yaml -o ./src/api"
  );

  if (stderr) {
    console.error(stderr);
  }
  if (stdout) {
    console.log(stdout);
  }
})();
