# AeroSales 气雾剂产品销售后端系统

AeroSales 是一个适合初学者练习、也可以写进简历的 Spring Boot 后端项目。第一版目标是实现一个最小可运行的气雾剂产品销售系统，覆盖产品浏览、SKU 规格、下单、库存扣减、订单查询和后台订单管理等核心流程。

## 技术栈

- Java 17
- Spring Boot 3.x
- Maven
- MySQL
- MyBatis-Plus
- Lombok
- Spring Validation
- Knife4j / OpenAPI

## 当前阶段

已完成第一阶段：项目初始化。

- 标准 Spring Boot Maven 项目结构
- 应用启动类 `AeroSalesApplication`
- 统一返回格式 `ApiResponse`
- 业务异常 `BusinessException`
- 全局异常处理 `GlobalExceptionHandler`
- 基础配置文件 `application.yml`
- 文档目录和 SQL 初始化脚本占位

## 本地启动方式

1. 确认本机已安装 JDK 17、Maven、MySQL。
2. 创建数据库：

```sql
CREATE DATABASE aerosales DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

3. 修改 `src/main/resources/application.yml` 中的数据库用户名和密码。
4. 启动项目：

```bash
mvn spring-boot:run
```

5. 启动成功后，默认服务地址：

```text
http://localhost:8080
```

Knife4j 接口文档地址后续会随着接口实现一起完善。

## 后续计划

- 第二阶段：设计数据库表并生成 `sql/init.sql`
- 第三阶段：实现产品、SKU、订单和后台管理接口
- 第四阶段：完善事务、库存扣减和统一异常处理
- 第五阶段：补充 README、数据库文档、接口文档和业务流程文档
