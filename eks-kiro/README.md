# Kiro CLI para DevOps en AWS — EKS y Multi-Cuenta

Aca te muestro como uso Kiro CLI como asistente en operaciones reales de AWS: administracion de clusters EKS, multiples cuentas, Terraform y troubleshooting.

Este repositorio contiene los archivos de configuracion de Steering, Skills y Agentes que uso en mi dia a dia. 

---


## Conceptos clave

### Steering

El Steering es memoria persistente para Kiro. En lugar de explicar tu entorno en cada sesion, defines archivos Markdown que Kiro carga automaticamente.

Hay dos tipos:

- **Global** (`~/.kiro/steering/`): aplica a todos tus proyectos. Aqui va tu inventario de cuentas, clusters, y reglas de seguridad absolutas.
- **Workspace** (`.kiro/steering/`): aplica solo al repositorio actual. Aqui va el stack tecnologico especifico y la estructura del proyecto.

### Skills

Las Skills son workflows reutilizables que Kiro puede activar automaticamente por contexto o mediante un slash command.

### Agentes

Los agentes combinan Steering, Skills y herramientas para ejecutar tareas complejas de forma autonoma. Pueden correr en modo interactivo o headless.

---

## Prerrequisitos

```bash
# Python 3.10 o superior
python3 --version

# uv (gestor de paquetes para el proxy de AWS MCP)
curl -LsSf https://astral.sh/uv/install.sh | sh

# kubectl
kubectl version --client

# AWS CLI v2
aws --version

# Kiro CLI
curl -fsSL https://cli.kiro.dev/install | bash
kiro-cli auth login
```

---

## Configuracion paso a paso

### Paso 1: Clonar y preparar la estructura

```bash
git clone https://github.com/tu-usuario/kiro-devops-aws.git
cd kiro-devops-aws

# Crear la estructura de directorios globales
mkdir -p ~/.kiro/steering
```

### Paso 2: Configurar el Steering global

Copia los archivos de steering global a tu directorio home y personaliza con tu informacion:

```bash
# Copiar plantillas
cp docs/templates/global-steering/identity.md            ~/.kiro/steering/
cp docs/templates/global-steering/aws-accounts.md        ~/.kiro/steering/
cp docs/templates/global-steering/eks-clusters.md        ~/.kiro/steering/
cp docs/templates/global-steering/security-non-negotiables.md ~/.kiro/steering/
cp docs/templates/global-steering/communication.md       ~/.kiro/steering/

# Editar con tu informacion real
# Reemplaza los valores de ejemplo por los tuyos:
# - Nombres de cuentas AWS y Account IDs
# - Nombres de clusters EKS
# - Perfiles de AWS CLI
# - Canales de Slack de tu equipo
```

### Paso 3: Configurar el Steering de workspace

Los archivos en `.kiro/steering/` ya estan incluidos en el repositorio con valores de ejemplo. Edita segun tu entorno:

```bash
# Editar inventario de cuentas AWS del proyecto
vim .kiro/steering/aws-accounts.md

# Editar inventario de clusters EKS del proyecto
vim .kiro/steering/eks-clusters.md
```

### Paso 4: Verificar que Kiro carga el contexto

```bash
# Iniciar una sesion en el directorio del proyecto
kiro-cli chat

# Dentro de la sesion, verificar el contexto cargado
> /context show

# Prueba rapida
> What is the upgrade order for EKS clusters in this project?
# Kiro debe responder con el orden definido en tu eks-clusters.md
```

### Paso 5: Probar las Skills

```bash
# Slash command explicito
kiro-cli chat
> /eks-cluster-health

# Activacion automatica por contexto
> I need to check if the cluster is healthy before deploying
# Kiro activa eks-cluster-health automaticamente
```

### Paso 6: Usar el agente de health check

```bash
# Modo interactivo
kiro-cli chat --agent eks-health-agent "Check the dev cluster"

# Con el script (reemplaza 'dev' por tu contexto de cluster)
chmod +x scripts/eks-health-check.sh
./scripts/eks-health-check.sh dev
./scripts/eks-health-check.sh dev --report    # genera archivo Markdown
./scripts/eks-health-check.sh all --report    # todos los clusters
```

---

## Configuracion de MCP para multiples cuentas AWS

El MCP (Model Context Protocol) permite a Kiro interactuar directamente con tus recursos de AWS. Para multiples cuentas, crea una entrada por cuenta en `~/.kiro/settings/mcp.json`:

```json
{
  "mcpServers": {
    "eks-dev": {
      "disabled": false,
      "type": "stdio",
      "command": "uvx",
      "args": [
        "mcp-proxy-for-aws@latest",
        "https://eks-mcp.us-east-1.api.aws/mcp",
        "--service", "eks-mcp",
        "--profile", "your-dev-profile",
        "--region",  "us-east-1"
      ]
    },
    "eks-prod": {
      "disabled": false,
      "type": "stdio",
      "command": "uvx",
      "args": [
        "mcp-proxy-for-aws@latest",
        "https://eks-mcp.us-east-1.api.aws/mcp",
        "--service", "eks-mcp",
        "--profile", "your-prod-profile",
        "--region",  "us-east-1",
        "--read-only"
      ]
    }
  }
}
```

Regla de seguridad: siempre agrega `--read-only` en los MCP servers de produccion. Kiro puede VER todo pero no puede MODIFICAR nada sin que lo hagas tu manualmente.

---

## Personalizacion de los archivos

### Que debes cambiar en cada archivo

**`.kiro/steering/aws-accounts.md`**

Reemplaza todos los valores de ejemplo:
- `your-org-management` por el alias real de tu cuenta de management
- `111111111111` por tus Account IDs reales
- `aws.example+alias@yourdomain.com` por los emails de tus cuentas
- Los grupos de cuentas por tu estructura de AWS Organizations

**`.kiro/steering/eks-clusters.md`**

Reemplaza:
- Los nombres de clusters (`myapp-dev-eks`) por los nombres reales de tus clusters
- Los Account IDs por los tuyos
- Los perfiles de AWS (`EKSDeploymentExecution_dev`) por los que tienes configurados
- La region (`us-east-1`) por la tuya

**`.kiro/agents/eks-health-agent/steering.md`**

El inventario de clusters en este archivo debe ser identico al de `eks-clusters.md`.

**`scripts/eks-health-check.sh`**

Actualiza el `CLUSTER_MAP` con tus contextos y clusters reales.

**`.github/workflows/eks-health-check.yml`**

Actualiza los ARNs de los roles de IAM y los nombres de clusters en la matriz de jobs.

---

## Idioma de los archivos de configuracion

- **Steering y Skills**: en ingles. Los modelos de IA razonan con mayor precision tecnica en ingles. Los terminos como `cluster-admin`, `least privilege`, `rollback` activan patrones de razonamiento mas ricos.
- **Comandos y codigo**: siempre en ingles, sin excepcion.
- **README y documentacion para tu equipo**: en el idioma que prefieras.

