subscription              = "e5240c8f-ec4f-4bd4-a36e-1981d27dd8e1"
cluster_name              = "AZ1Q-AKS-PIERFLEX-1"
resource_group_name       = "RG_PIERFLEX_AKS_QA"
rancher_url               = "https://rancher.devcdt.com.br"
harness_secret_manager_id = "HLTEHnLcQf6hi6CeQyu7pw"
harness_account_id        = "105DaJ5nRO-fBUdVr8ZIKw"
harness_application_id    = "A9b9PykZQaymkALMQaqpjA"
environment_id            = "c9SIZtYITwmaeYXxvW39_w"

#Pierflex Namespaces
pierflex_namespaces = [
  {
    "name"  = "account",
    "istio" = "enabled"
  },
  {
    "name"  = "aggregator",
    "istio" = "enabled"
  },

  {
    "name"  = "billing",
    "istio" = "enabled"
  },
  {
    "name"  = "clearingconnector",
    "istio" = "enabled"
  },
  {
    "name"  = "control",
    "istio" = "enabled"
  },
  {
    "name"  = "dataenrichment",
    "istio" = "enabled"
  },
  {
    "name"  = "events",
    "istio" = "enabled"
  },
  {
    "name"  = "exchange",
    "istio" = "enabled"
  },
  {
    "name"  = "falconcardconnectorpci",
    "istio" = "enabled"
  },
  {
    "name"  = "falconconnector",
    "istio" = "enabled"
  },
  {
    "name"  = "installment",
    "istio" = "enabled"
  },
  {
    "name"  = "operation",
    "istio" = "enabled"
  },
  {
    "name"  = "orchestrator",
    "istio" = "enabled"
  },
  {
    "name"  = "person",
    "istio" = "enabled"
  },
  {
    "name"  = "piercards",
    "istio" = "enabled"
  },
  {
    "name"  = "product",
    "istio" = "enabled"
  },
  {
    "name"  = "statement",
    "istio" = "enabled"
  },
  {
    "name"  = "transaction",
    "istio" = "enabled"
  },
  {
    "name"  = "vhub",
    "istio" = "enabled"
  }
]