CREATE DATABASE IF NOT EXISTS aerosales
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE aerosales;

DROP TABLE IF EXISTS stock_log;
DROP TABLE IF EXISTS sales_order_item;
DROP TABLE IF EXISTS sales_order;
DROP TABLE IF EXISTS product_sku;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS product_category;

CREATE TABLE product_category (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '分类ID',
    name VARCHAR(100) NOT NULL COMMENT '分类名称',
    sort_order INT NOT NULL DEFAULT 0 COMMENT '排序值',
    status VARCHAR(20) NOT NULL DEFAULT 'ON_SALE' COMMENT '状态',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    KEY idx_status_sort (status, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产品分类表';

CREATE TABLE product (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '产品ID',
    category_id BIGINT NOT NULL COMMENT '分类ID',
    name VARCHAR(150) NOT NULL COMMENT '产品名称',
    brand VARCHAR(100) NOT NULL COMMENT '品牌',
    description TEXT COMMENT '产品描述',
    status VARCHAR(20) NOT NULL DEFAULT 'ON_SALE' COMMENT '状态：ON_SALE/OFF_SALE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    KEY idx_category_id (category_id),
    KEY idx_status (status),
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id) REFERENCES product_category (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产品表';

CREATE TABLE product_sku (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'SKU ID',
    product_id BIGINT NOT NULL COMMENT '产品ID',
    sku_name VARCHAR(150) NOT NULL COMMENT 'SKU名称',
    volume VARCHAR(50) NOT NULL COMMENT '容量规格',
    package_spec VARCHAR(100) NOT NULL COMMENT '包装规格',
    price DECIMAL(10, 2) NOT NULL COMMENT '销售价格',
    stock INT NOT NULL DEFAULT 0 COMMENT '当前库存',
    warning_stock INT NOT NULL DEFAULT 0 COMMENT '库存预警值',
    storage_condition VARCHAR(255) COMMENT '存储条件',
    transport_note VARCHAR(255) COMMENT '运输说明',
    status VARCHAR(20) NOT NULL DEFAULT 'ON_SALE' COMMENT '状态：ON_SALE/OFF_SALE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    KEY idx_product_id (product_id),
    KEY idx_status (status),
    KEY idx_stock (stock),
    CONSTRAINT fk_sku_product
        FOREIGN KEY (product_id) REFERENCES product (id),
    CONSTRAINT chk_sku_price_non_negative CHECK (price >= 0),
    CONSTRAINT chk_sku_stock_non_negative CHECK (stock >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产品规格表';

CREATE TABLE customer (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '客户ID',
    nickname VARCHAR(100) NOT NULL COMMENT '客户昵称',
    phone VARCHAR(30) NOT NULL COMMENT '手机号',
    customer_type VARCHAR(30) NOT NULL DEFAULT 'RETAIL' COMMENT '客户类型',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uk_phone (phone),
    KEY idx_customer_type (customer_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户表';

CREATE TABLE sales_order (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '订单ID',
    order_no VARCHAR(40) NOT NULL COMMENT '订单编号',
    customer_id BIGINT NOT NULL COMMENT '客户ID',
    total_amount DECIMAL(10, 2) NOT NULL COMMENT '订单总金额',
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING_PAYMENT' COMMENT '订单状态',
    receiver_name VARCHAR(100) NOT NULL COMMENT '收货人姓名',
    receiver_phone VARCHAR(30) NOT NULL COMMENT '收货人手机号',
    receiver_address VARCHAR(255) NOT NULL COMMENT '收货地址',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    paid_at DATETIME NULL COMMENT '支付时间',
    cancelled_at DATETIME NULL COMMENT '取消时间',
    completed_at DATETIME NULL COMMENT '完成时间',
    UNIQUE KEY uk_order_no (order_no),
    KEY idx_customer_id (customer_id),
    KEY idx_status (status),
    KEY idx_created_at (created_at),
    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id) REFERENCES customer (id),
    CONSTRAINT chk_order_total_non_negative CHECK (total_amount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';

CREATE TABLE sales_order_item (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '订单明细ID',
    order_id BIGINT NOT NULL COMMENT '订单ID',
    sku_id BIGINT NOT NULL COMMENT 'SKU ID',
    product_name VARCHAR(150) NOT NULL COMMENT '下单时产品名称快照',
    sku_name VARCHAR(150) NOT NULL COMMENT '下单时SKU名称快照',
    quantity INT NOT NULL COMMENT '购买数量',
    unit_price DECIMAL(10, 2) NOT NULL COMMENT '下单时单价',
    subtotal DECIMAL(10, 2) NOT NULL COMMENT '小计金额',
    KEY idx_order_id (order_id),
    KEY idx_sku_id (sku_id),
    CONSTRAINT fk_order_item_order
        FOREIGN KEY (order_id) REFERENCES sales_order (id),
    CONSTRAINT fk_order_item_sku
        FOREIGN KEY (sku_id) REFERENCES product_sku (id),
    CONSTRAINT chk_order_item_quantity_positive CHECK (quantity > 0),
    CONSTRAINT chk_order_item_unit_price_non_negative CHECK (unit_price >= 0),
    CONSTRAINT chk_order_item_subtotal_non_negative CHECK (subtotal >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单明细表';

CREATE TABLE stock_log (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '库存流水ID',
    sku_id BIGINT NOT NULL COMMENT 'SKU ID',
    change_type VARCHAR(30) NOT NULL COMMENT '变更类型',
    quantity INT NOT NULL COMMENT '变更数量',
    before_stock INT NOT NULL COMMENT '变更前库存',
    after_stock INT NOT NULL COMMENT '变更后库存',
    related_order_id BIGINT NULL COMMENT '关联订单ID',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    KEY idx_sku_id (sku_id),
    KEY idx_related_order_id (related_order_id),
    KEY idx_created_at (created_at),
    CONSTRAINT fk_stock_log_sku
        FOREIGN KEY (sku_id) REFERENCES product_sku (id),
    CONSTRAINT fk_stock_log_order
        FOREIGN KEY (related_order_id) REFERENCES sales_order (id),
    CONSTRAINT chk_stock_log_after_non_negative CHECK (after_stock >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库存流水表';

INSERT INTO product_category (id, name, sort_order, status, created_at, updated_at) VALUES
(1, '家居清洁气雾剂', 10, 'ON_SALE', NOW(), NOW()),
(2, '汽车护理气雾剂', 20, 'ON_SALE', NOW(), NOW()),
(3, '工业维护气雾剂', 30, 'ON_SALE', NOW(), NOW());

INSERT INTO product (id, category_id, name, brand, description, status, created_at, updated_at) VALUES
(1, 1, '厨房强力除油气雾剂', 'AeroClean', '适用于厨房灶台、油烟机和瓷砖表面的油污清洁。', 'ON_SALE', NOW(), NOW()),
(2, 1, '浴室除霉清洁气雾剂', 'AeroClean', '用于浴室墙面、玻璃胶边和瓷砖缝隙的日常清洁。', 'ON_SALE', NOW(), NOW()),
(3, 2, '汽车内饰清洁气雾剂', 'AeroCar', '适用于汽车仪表台、门板、座椅边角等内饰区域。', 'ON_SALE', NOW(), NOW()),
(4, 2, '轮毂去污护理气雾剂', 'AeroCar', '帮助清洁轮毂刹车粉尘和道路污渍。', 'ON_SALE', NOW(), NOW()),
(5, 3, '多用途防锈润滑气雾剂', 'AeroPro', '适用于金属零件、铰链、链条等部位的润滑和防锈。', 'ON_SALE', NOW(), NOW());

INSERT INTO product_sku (
    id, product_id, sku_name, volume, package_spec, price, stock, warning_stock,
    storage_condition, transport_note, status, created_at, updated_at
) VALUES
(1, 1, '厨房强力除油 300ml 单瓶装', '300ml', '1瓶/盒', 29.90, 120, 20, '阴凉干燥处保存，远离火源。', '按普通日化品运输，避免高温暴晒。', 'ON_SALE', NOW(), NOW()),
(2, 1, '厨房强力除油 500ml 家庭装', '500ml', '1瓶/盒', 39.90, 80, 15, '阴凉干燥处保存，远离火源。', '按普通日化品运输，避免高温暴晒。', 'ON_SALE', NOW(), NOW()),
(3, 2, '浴室除霉 300ml 单瓶装', '300ml', '1瓶/盒', 32.90, 100, 20, '阴凉通风处保存。', '运输时保持瓶体直立。', 'ON_SALE', NOW(), NOW()),
(4, 3, '汽车内饰清洁 450ml 单瓶装', '450ml', '1瓶/盒', 45.00, 90, 15, '避免阳光直射，远离儿童。', '避免挤压和高温环境。', 'ON_SALE', NOW(), NOW()),
(5, 3, '汽车内饰清洁 450ml 双瓶装', '450ml*2', '2瓶/套', 82.00, 60, 10, '避免阳光直射，远离儿童。', '避免挤压和高温环境。', 'ON_SALE', NOW(), NOW()),
(6, 4, '轮毂去污护理 500ml 单瓶装', '500ml', '1瓶/盒', 49.90, 70, 12, '阴凉处保存，使用后盖紧。', '运输时避免剧烈碰撞。', 'ON_SALE', NOW(), NOW()),
(7, 5, '防锈润滑 350ml 单瓶装', '350ml', '1瓶/盒', 36.00, 150, 30, '远离火源和热源，置于通风处。', '气雾剂产品运输需避免高温。', 'ON_SALE', NOW(), NOW()),
(8, 5, '防锈润滑 350ml 工具箱套装', '350ml', '3瓶/套', 99.00, 45, 8, '远离火源和热源，置于通风处。', '气雾剂产品运输需避免高温。', 'ON_SALE', NOW(), NOW());

INSERT INTO customer (id, nickname, phone, customer_type, created_at, updated_at) VALUES
(1, '测试客户A', '13800000001', 'RETAIL', NOW(), NOW()),
(2, '测试客户B', '13800000002', 'WHOLESALE', NOW(), NOW());
