```text
Internet
    │
    ▼
Ingress
    │
    ▼
Service
    │
    ▼
Deployment
    │
    ├── Pod 1
    │   ├── Container
    │   ├── ConfigMap
    │   ├── Secret
    │   ├── Volume
    │   └── Probes
    │       ├── Startup
    │       ├── Readiness
    │       └── Liveness
    │
    ├── Pod 2
    │   └── Container
    │
    └── Pod 3
        └── Container

Cluster
│
├── Node 1
│   ├── Pod 1
│   └── Pod 2
│
└── Node 2
    └── Pod 3

NetworkPolicy
└── Kiểm soát Pod nào được phép giao tiếp với Pod nào
```

```text
Cluster → Node → Pod → Container

Internet → Ingress → Service → Deployment → Pod
```
