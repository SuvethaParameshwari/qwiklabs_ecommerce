view: order_items {
  sql_table_name: `cloud-training-demos.looker_ecomm.order_items`
    ;;
  drill_fields: [order_item_id]

  dimension: order_item_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;

  }


  dimension_group: first_order {
    type: time
    timeframes: [time, date, week, month, raw]
    sql: ${TABLE}.created_at ;;
  }

  measure: first_order_created_date {
    type: date
    sql: MIN(${created_raw}) ;;
    convert_tz: no
  }

 measure: customer_lifetime_orders {
    case: {
      when: {
        sql: ${order_count} = 1;;
        label: "1 Order"
      }
      when: {
        sql: ${order_count} = 2;;
        label: "2 Orders"
      }
      when: {
        sql: ${order_count} > 2 AND ${order_count} <= 5;;
        label: "3-5 Orders"
      }
      when: {
        sql: ${order_count} > 5 AND ${order_count} <= 9;;
        label: "5-9 Orders"
      }
      when: {
        sql: ${order_count} > 9;;
        label: "10+ Orders"
      }
      else:"Unknown"
    }
  }
  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  #  html: {{ rendered_value | date: "%B, %Y" }} ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

measure: average_gross_margin {
  type: number
  sql:avg(order_items.sale_price - ${products.cost});;
  value_format_name: usd
}
  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    drill_fields: [detail*]
    value_format_name: usd_0
  }

  measure: order_item_count {
    type: count
    drill_fields: [detail*]
  }

  measure: order_count {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_revenue {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: millions
  }

  measure: total_revenue_by_brand {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: millions
   # filters: []
  }

  measure: total_gross_revenue{
    type: sum
    sql: ${sale_price} ;;
  #  filters: [status: "Completed,Shipped,Processing",created_date: "last year"]
    filters: [status: "Completed,Shipped,Processing"]
  #  filters: [status: "-Cancelled,-Returned]
    value_format_name: usd
  }

measure: total_gross_margin {
  type: number
  sql: ${total_revenue}-${inventory_items.total_cost} ;;
  #filters: [created_date: "last year"]
  value_format_name: millions
}
measure: count_of_returned_orders {
  type: count_distinct
  filters: [status: "Returned"]
}
measure: revenue_yesterday {
  type: sum
  sql: ${sale_price} ;;
  filters: [ created_date: "yesterday"]
  value_format_name: millions
  }
 # matches_filter(${sales_field}, `yesterday`)


measure: average_spend_per_customer {
  type: number
  sql: ${total_revenue} /${users.count};;
  value_format_name: usd
  drill_fields: [users.id,users.age,users.gender,]
}
measure: users_returning_orders_count {
  type: count_distinct
  sql: ${user_id} ;;
  filters: [status: "Returned"]
}

measure: percentage_of_users_with_returns {
  type: number
  sql: ${users_returning_orders_count}/${users.count} ;;
  value_format_name: decimal_2
}
measure: item_return_rate {
  type: number
  sql: ${count_of_returned_orders}/${order_count} ;;
  value_format_name: decimal_2
}
measure: gross_margin_percentage {
  type: number
  sql: ${total_gross_margin}/${total_gross_revenue} ;;
  value_format_name: decimal_2
}

  #measure: gross_margin_percentage_last_year{
  # type: sum
   # sql: ${total_gross_margin}/${total_gross_revenue} ;;
  #  matches_filter(${created_date}, `yesterday`)
  #  value_format_name: decimal_2
  #}
#  dimension: average_gross_margin {
#    type: number
#   sql: AVG(${total_revenue}-${inventory_items.total_cost});;
#    value_format_name:usd
#  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      order_item_id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
