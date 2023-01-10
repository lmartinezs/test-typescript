module.exports = {
  default: [
    "--require-module ts-node/register",
    "--require features/**/*.ts",
    "--format html:cucumber-report.html",
    "--publish-quiet",
  ].join(" "),
};
