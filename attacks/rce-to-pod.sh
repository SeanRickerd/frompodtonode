#!/bin/bash

# ===== Config =====
NAMESPACE="compromised-app"
TARGET="10.42.0.12"
LHOST="10.0.2.15"
LPORT="4444"

# ===== Colors =====
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

# ===== Helper: jitter sleep =====
jitter() {
  awk -v min=0.02 -v max=0.08 'BEGIN{srand(); print min+rand()*(max-min)}'
}

# ===== Get pod name dynamically =====
WEBAPP=$(kubectl get pods -n $NAMESPACE \
  --no-headers \
  -o custom-columns=":metadata.name" | head -n 1)

if [ -z "$WEBAPP" ]; then
  echo "[-] No pod found in namespace $NAMESPACE"
  exit 1
fi

echo "[*] Target pod: $WEBAPP"
echo ""

# ===== Hollywood Exploit Output =====
run_exploit() {
  echo -e "${YELLOW}[*] Target: ${TARGET}:80${NC}"
  sleep 0.3

  echo -e "${YELLOW}[*] Scanning ingress endpoints...${NC}"
  sleep 0.4

  echo -e "${GREEN}[+] CVE-2025-XXXX detected (RCE)${NC}"
  sleep 0.4

  echo -e "${YELLOW}[*] Preparing exploit payload...${NC}"
  sleep 0.3

  for i in $(seq 1 25); do
    echo -e "${GREEN}[+] Spraying payload chunk $i/25...${NC}"
    sleep $(jitter)
  done

  echo -e "${YELLOW}[*] Attempting WAF bypass...${NC}"
  sleep 0.4

  echo -e "${GREEN}[+] WAF bypass successful${NC}"
  sleep 0.3

  echo -e "${YELLOW}[*] Injecting malicious NGINX configuration...${NC}"
  sleep 0.4

  echo -e "${YELLOW}[*] Forcing config reload...${NC}"
  sleep 0.4

  echo -e "${YELLOW}[*] Establishing reverse channel to ${LHOST}:${LPORT}...${NC}"
  sleep 0.8

  echo ""
  echo -e "${GREEN}[+] Connection received from ${TARGET}:49832${NC}"
  sleep 0.4

  echo -e "${GREEN}[+] PTY allocated${NC}"
  echo ""

  echo -e "${RED}███████╗██╗  ██╗███████╗██╗     ██╗     "
  echo -e "██╔════╝██║  ██║██╔════╝██║     ██║     "
  echo -e "███████╗███████║█████╗  ██║     ██║     "
  echo -e "╚════██║██╔══██║██╔══╝  ██║     ██║     "
  echo -e "███████║██║  ██║███████╗███████╗███████╗"
  echo -e "╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝${NC}"

  echo ""
  echo -e "${GREEN}[+] Shell obtained${NC}"
  echo ""
}

# ===== Run exploit output =====
run_exploit

# ===== Drop into pod =====
echo "[*] Dropping into compromised pod..."
kubectl exec -n $NAMESPACE -it $WEBAPP -- sh
