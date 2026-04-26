# 数据库设计

数据库名称：`aerosales`

本项目使用 MySQL 保存产品分类、产品、SKU、客户、订单、订单明细和库存流水数据。金额字段统一使用 `DECIMAL(10,2)`，时间字段统一使用 `DATETIME`，状态字段统一使用 `VARCHAR`，方便初学阶段理解和扩展。

## product_category

产品分类表，用于管理气雾剂产品的分类，例如家居清洁、汽车护理、工业维护。

主要字段：

- `id`：分类主键，自增
- `name`：分类名称
- `sort_order`：排序值
- `status`：分类状态
- `created_at`：创建时间
- `updated_at`：更新时间

## product

产品表，用于保存产品的基础信息。一个分类下可以有多个产品。

主要字段：

- `id`：产品主键，自增
- `category_id`：所属分类 ID
- `name`：产品名称
- `brand`：品牌
- `description`：产品描述
- `status`：产品状态，当前规划为 `ON_SALE`、`OFF_SALE`
- `created_at`：创建时间
- `updated_at`：更新时间

## product_sku

产品 SKU 表，用于保存具体可售卖规格。一个产品可以有多个 SKU，例如 300ml 单瓶装、500ml 家庭装。

主要字段：

- `id`：SKU 主键，自增
- `product_id`：所属产品 ID
- `sku_name`：SKU 名称
- `volume`：容量规格
- `package_spec`：包装规格
- `price`：销售价格，使用 `DECIMAL(10,2)`
- `stock`：当前库存
- `warning_stock`：库存预警值
- `storage_condition`：存储条件
- `transport_note`：运输说明
- `status`：SKU 状态，当前规划为 `ON_SALE`、`OFF_SALE`
- `created_at`：创建时间
- `updated_at`：更新时间

## customer

客户表，用于保存下单客户的基础信息。第一版不做真实登录，只使用测试客户模拟下单。

主要字段：

- `id`：客户主键，自增
- `nickname`：客户昵称
- `phone`：手机号
- `customer_type`：客户类型，例如 `RETAIL`、`WHOLESALE`
- `created_at`：创建时间
- `updated_at`：更新时间

## sales_order

订单表，用于保存订单主信息，例如订单号、客户、总金额、收货信息和订单状态。

主要字段：

- `id`：订单主键，自增
- `order_no`：订单编号，唯一
- `customer_id`：客户 ID
- `total_amount`：订单总金额，使用 `DECIMAL(10,2)`
- `status`：订单状态，当前规划为 `PENDING_PAYMENT`、`PAID`、`CANCELLED`、`COMPLETED`
- `receiver_name`：收货人姓名
- `receiver_phone`：收货人手机号
- `receiver_address`：收货地址
- `created_at`：创建时间
- `paid_at`：支付时间
- `cancelled_at`：取消时间
- `completed_at`：完成时间

## sales_order_item

订单明细表，用于保存订单中的每一个 SKU。下单时会保存产品名、SKU 名和单价快照，避免后续产品信息变化影响历史订单。

主要字段：

- `id`：订单明细主键，自增
- `order_id`：订单 ID
- `sku_id`：SKU ID
- `product_name`：下单时产品名称快照
- `sku_name`：下单时 SKU 名称快照
- `quantity`：购买数量
- `unit_price`：下单时单价，使用 `DECIMAL(10,2)`
- `subtotal`：小计金额，使用 `DECIMAL(10,2)`

## stock_log

库存流水表，用于记录每次库存变化。创建订单扣减库存、后台调整库存时都应该写入流水，方便追踪库存变化来源。

主要字段：

- `id`：库存流水主键，自增
- `sku_id`：SKU ID
- `change_type`：库存变更类型，例如 `ORDER_DEDUCT`、`ADMIN_ADJUST`
- `quantity`：变更数量
- `before_stock`：变更前库存
- `after_stock`：变更后库存
- `related_order_id`：关联订单 ID，后台手动调整时可以为空
- `created_at`：创建时间

## 测试数据

`sql/init.sql` 已包含基础测试数据：

- 3 个产品分类
- 5 个气雾剂产品
- 8 个 SKU，每个产品 1-2 个 SKU
- 2 个测试客户
