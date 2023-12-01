# Dine-out
Página de reservas para restaurantes.

## Módulos desarrollados
Marcados con un asterisco se encuentran los módulos seleccionados para corrección

### Cloudfront (*)
Funciona como CDN. También hace caché de los contenidos de la API y del frontend del S3.

### API Gateway (*)
Levanta una API REST que permite llamar a las funciones `lambda`. Se permiten los métodos `GET`, `POST` y `OPTIONS`.

### DynamoDB (*)
Crea la tabla `Restaurants` en Dynamo. La misma tiene los atributos `Name` de tipo `string` y `id` de tipo `number`.

### Funciones Lambda (*)
Crea dos funciones lambda, que permiten escribir restaurantes nuevos y leer la lista de restaurantes de la tabla `Restaurants`.

### VPC y subnets (*)
Crea la VPC con su correspondiente CIDR y subredes para alojar a las funciones lambda.

### S3 Buckets (*)
Bucket para el frontend. [Módulo externo](https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest/examples/complete).

### Route tables
Tablas de ruteo para las subredes

### VPC Endpoint
Endpoints para conectar a la VPC con DynamoDB.

## Meta-argumentos
Se adjunta referencia a uno solo de los usos de los meta-argumentos.
+ [for-each](https://github.com/juani-garcia/2023Q2-G3/blob/main/terraform/modules/cloudfront/main.tf)
+ [depends-on](https://github.com/juani-garcia/2023Q2-G3/blob/main/terraform/lambda.tf)
+ [lifecycle](https://github.com/juani-garcia/2023Q2-G3/blob/main/terraform/modules/apigw/main.tf)

## Built-ins
Se adjunta referencia a uno solo de los usos de las funciones.
+ [replace](https://github.com/juani-garcia/2023Q2-G3/blob/main/terraform/cloudfront.tf)
+ [sha1](https://github.com/juani-garcia/2023Q2-G3/blob/main/terraform/modules/apigw/main.tf)
+ [jsonencode](https://github.com/juani-garcia/2023Q2-G3/blob/main/terraform/modules/apigw/main.tf)
+ [file](https://github.com/juani-garcia/2023Q2-G3/blob/main/terraform/locals.tf)
+ [filemd5](https://github.com/juani-garcia/2023Q2-G3/blob/main/terraform/s3.tf)

## Diagrama de la arquitectura
![Diagrama de la arquitectura](https://github.com/juani-garcia/2023Q2-G3/blob/main/docs/DineOut.png)
Es importante comentar que, por limitaciones de tiempo, no pudimos conectar correctamente las Lambda a DynamoDB para que la misma sea modificada por el usuario. A su vez, no se pudo habilitar correctamente la CORS policy para que Cloudfront se conecte con el API gateway.

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
