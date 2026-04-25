# Lab 1 — Tu primer llamado a un LLM con AWS CLI

> **Dominio del examen:** Generative AI · Foundation Models  
> **Duración:** ~6 minutos  
> **Costo estimado:** ~$0.01 USD  
> **📺 Video:** [Ver en YouTube](https://youtube.com)

---

## 🎯 Qué aprenderás

Al terminar este lab entenderás en la práctica:

- Qué es un **Foundation Model** y cómo se invoca
- Qué es **inference** (vs training)
- Qué es **token-based pricing** y cómo leerlo en el JSON de respuesta
- Por qué Bedrock es un **managed service** (serverless)

> **Analogía clave:** Amazon Bedrock es como API Gateway para modelos de IA.
> Así como API Gateway te expone un endpoint para invocar tu Lambda sin gestionar
> servidores, Bedrock te da un endpoint para invocar Claude sin gestionar
> ninguna infraestructura de ML.

---

## ⚙️ Prerrequisitos

```bash
# AWS CLI v2 configurado
aws configure
# Access Key ID: [tu key]
# Secret Access Key: [tu secret]
# Default region: us-east-1
# Output format: json

# Acceso a modelos habilitado en Bedrock Console:
# Amazon Bedrock → Model access → Enable → Claude 3 Haiku
```

---

## 📁 Archivos

```
lab1-bedrock-invoke/
├── invoke.sh       ← script principal (corre esto)
└── request.json    ← payload del prompt
```

---

## 🚀 Cómo correr el lab

```bash
cd lab1-bedrock-invoke
chmod +x invoke.sh
./invoke.sh
```

---

## 📄 Archivos del lab

### `request.json` — El payload del prompt

```json
{
  "anthropic_version": "bedrock-2023-05-31",
  "max_tokens": 200,
  "messages": [
    {
      "role": "user",
      "content": "Explica en 2 oraciones qué es un foundation model"
    }
  ]
}
```

**Tres campos que el examen pregunta:**

| Campo | Por qué importa |
|-------|----------------|
| `anthropic_version` | Cada proveedor tiene su propio formato — esto es model-specific API |
| `max_tokens` | Controla el tamaño de la respuesta y afecta el **costo** directamente |
| `role: "user"` | Define el turno en la conversación — el modelo "completa" la respuesta |

---

### Comando principal

```bash
aws bedrock-runtime invoke-model \
  --model-id anthropic.claude-haiku-4-5-20251001 \
  --body file://request.json \
  --region us-east-1 \
  response.json && cat response.json | jq '.content[0].text'
```

---

### Output esperado

```json
{
  "content": [
    {
      "type": "text",
      "text": "Un foundation model es un modelo de IA entrenado con grandes cantidades..."
    }
  ],
  "stop_reason": "end_turn",
  "usage": {
    "input_tokens": 18,
    "output_tokens": 47
  }
}
```

**Campos clave para el examen:**

| Campo | Significado |
|-------|-------------|
| `stop_reason: end_turn` | El modelo terminó naturalmente |
| `stop_reason: max_tokens` | La respuesta fue cortada — aumenta `max_tokens` |
| `usage.input_tokens` | Tokens del prompt — parte del costo |
| `usage.output_tokens` | Tokens generados — parte del costo |

---

## 🔧 Troubleshooting

| Error | Causa | Solución |
|-------|-------|----------|
| `AccessDeniedException` | Modelo no habilitado | Bedrock Console → Model access → Enable Claude Haiku |
| `UnrecognizedClientException` | Credenciales inválidas | `aws configure` y verificar región |
| `ValidationException` | JSON malformado | `cat request.json \| jq .` para validar |

---

## 📚 Pregunta típica del examen

> *"Una empresa quiere invocar modelos de lenguaje sin gestionar infraestructura de ML.
> ¿Qué servicio de AWS utilizaría?"*

**Respuesta:** Amazon Bedrock — managed service, serverless, token-based pricing.

---

## 🔗 Documentación oficial

- [Bedrock InvokeModel API](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_InvokeModel.html)
- [Claude Messages API en Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-anthropic-claude-messages.html)
- [Bedrock Pricing](https://aws.amazon.com/bedrock/pricing/)
