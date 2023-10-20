# Dine-out
Página de reservas para restaurantes.

## Módulos desarrollados
Desarrollamos únicamente seis módulos, de los cuáles todos se entregan para corrección.

### Cloudfront
Funciona como CDN. También hace caché de los contenidos de la API y del frontend del S3.

### API Gateway
Levanta una API REST que permite llamar a las funciones `lambda`. Se permiten los métodos `GET`y `POST`.

### DynamoDB
Crea la tabla `Restaurants` en Dynamo. La misma tiene los atributos `Name` de tipo `string` y `id` de tipo `number`.

### Funciones Lambda
Crea dos funciones lambda, que permiten escribir restaurantes nuevos y leer la lista de restaurantes de la tabla `Restaurants`.

### VPC y subnets
Crea la VPC con su correspondiente CIDR y subredes para alojar a las funciones lambda.

### S3 Buckets
Bucket para el frontend. [Módulo externo](https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest/examples/complete).

## Meta-argumentos
+ for-each
+ depends-on
+ lifecycle

## Built-ins
+ fileset
+ replace
+ sha1
+ jsonencode

## Rúbrica
<table>
    <tr>
        <td>Juan Ignacio García Matwieiszyn</td>
        <td>61441</td>
        <td>25%</td>
    </tr>
    <tr>
        <td>Juan Martín Barmasch</td>
        <td>61033</td>
        <td>25%</td>
    </tr>
    <tr>
        <td>Camila Collado</td>
        <td>61487</td>
        <td>25%</td>
    </tr>
    <tr>
        <td>Andrés Podgorny</td>
        <td>60570</td>
        <td>25%</td>
    </tr>
</table>
