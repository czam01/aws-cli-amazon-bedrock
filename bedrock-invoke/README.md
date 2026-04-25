# Lab 1 — Tu primer llamado a un LLM con AWS CLI

> **Dominio del examen:** Generative AI · Foundation Models  
> **Duración:** ~15 minutos  
> **Costo estimado:** ~$0.01 USD  

---

## Qué aprenderás

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

## Prerrequisitos

```bash
# AWS CLI v2 configurado
aws configure
# Access Key ID: [tu key]
# Secret Access Key: [tu secret]
# Default region: us-east-1
# Output format: json

# Acceso a modelos habilitado en Bedrock Console:
```

---

## Archivos

```
lab1-bedrock-invoke/
├── invoke.sh       ← script principal (corre esto)
├── request.json    ← payload del prompt
└── request_system.json    ← payload del prompt con instruccion al sistema
```

---

## Archivos del lab

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
  --model-id us.anthropic.claude-haiku-4-5-20251001-v1:0 \
  --body file://request.json \
  --content-type application/json \
  --accept application/json \
  --region us-east-1 \
  --cli-binary-format raw-in-base64-out \
  response.json
```

---

### Output esperado

```json
❯ cat response.json | jq .                                      
{
  "model": "claude-haiku-4-5-20251001",
  "id": "msg_bdrk_01UWE2dFvpor9ATmLVYQ9Jba",
  "type": "message",
  "role": "assistant",
  "content": [
    {
      "type": "text",
      "text": "# Certificaciones de AWS\n\nAWS ofrece un programa de certificación bien estructurado para validar tus habilidades en la plataforma. Te cuento los detalles:\n\n## **Niveles de Certificación**\n\n### 🟢 **Foundational (Principiante)**\n- **AWS Certified Cloud Practitioner**\n  - Para principiantes sin experiencia técnica\n  - Cubre conceptos básicos de AWS\n  - ~60-90 horas de estudio\n\n### 🔵 **Associate (Intermedio)**\n- **Solutions Architect Associate**\n  - Diseño de soluciones en AWS\n  - Muy popular y demandada\n\n- **Developer Associate**\n  - Desarrollo de aplicaciones\n  - Enfoque en código y APIs\n\n- **SysOps Administrator Associate**\n  -"
    }
  ],
  "stop_reason": "max_tokens",
  "stop_sequence": null,
  "usage": {
    "input_tokens": 17,
    "cache_creation_input_tokens": 0,
    "cache_read_input_tokens": 0,
    "cache_creation": {
      "ephemeral_5m_input_tokens": 0,
      "ephemeral_1h_input_tokens": 0
    },
    "output_tokens": 200
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


## Documentación oficial

- [Bedrock InvokeModel API](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_InvokeModel.html)
- [Claude Messages API en Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-anthropic-claude-messages.html)
- [Bedrock Pricing](https://aws.amazon.com/bedrock/pricing/)
