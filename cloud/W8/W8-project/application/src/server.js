const express = require("express");
const path = require("path");
const { projects } = require("./data");
const apiRoutes = require("./routes/api");

const app = express();
const port = Number(process.env.PORT || 3000);

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));
app.use("/api", apiRoutes);

app.get("/health", (_req, res) => {
  res.json({ ok: true });
});

app.get("/", (_req, res) => {
  res.render("index", {
    pageTitle: process.env.APP_TITLE || "Minikube On AWS",
    appStage: process.env.APP_STAGE || "Single EC2 + ALB",
    clusterName: "minikube",
    repoMode: "Terraform 1-Click",
    projects
  });
});

app.listen(port, () => {
  console.log(`Server listening on http://localhost:${port}`);
});
