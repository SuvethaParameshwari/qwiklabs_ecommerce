# created by arul for grouping of order count
view: orders {
  derived_table: {
    sql: SELECT
          order_items.user_id  AS order_items_user_id,
          COUNT(DISTINCT order_items.order_id ) AS order_items_order_count
      FROM `cloud-training-demos.looker_ecomm.order_items`
           AS order_items
      GROUP BY
          1
      ORDER BY
          2 DESC
       ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.order_items_user_id ;;
  }

  dimension: order_count {
    type: number
    sql: ${TABLE}.order_items_order_count ;;
  }

  set: detail {
    fields: [
        user_id,
  order_count
    ]
  }
}
