REGION="us-east-1"
MODEL_ID="usanthropic.claude-haiku-4-5-20251001-v1:0"

# ── PASO 1: Verificar acceso al modelo ──────────────────────
aws bedrock list-foundation-models --region us-east-1 \
     --query "modelSummaries[?starts_with(modelId, 'anthropic.claude')].[modelId]" \
     --output table

# ── PASO 2: Invocar el modelo ───────────────────────────────
aws bedrock-runtime invoke-model \
  --model-id us.anthropic.claude-haiku-4-5-20251001-v1:0 \
  --body file://request.json \
  --content-type application/json \
  --accept application/json \
  --region us-east-1 \
  --cli-binary-format raw-in-base64-out \
  response.json

# ── PASO 3: Mostrar la respuesta limpia ─────────────────────
cat response.json | jq .
