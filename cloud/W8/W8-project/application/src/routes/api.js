const express = require("express");
const { projects } = require("../data");

const router = express.Router();

router.get("/projects", (_req, res) => {
  res.json({
    ok: true,
    cluster: "minikube",
    count: projects.length,
    projects
  });
});

module.exports = router;
