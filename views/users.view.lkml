view: users {
  sql_table_name: `cloud-training-demos.looker_ecomm.users`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;

  }

#dimension: is_before_mtd {
# type: yesno
# sql:  ${created_date} < extract_days(CURRENT_TIMESTAMP);;
#
 # dimension: order_tiers {
#    type: tier
#    style:integer
#    tiers: [0,1,2,5,10]
#    sql: ${TABLE}.order_count ;;
#   dimensio
#  }




 # dimension: todays_date {
#    type: date
#    sql: add_days(-1,trunc_days(now( )));;
#    convert_tz: no
#  }



  dimension: age_tiers {
    type: tier
    style:integer
    tiers: [15,25,35,50,66]
    sql: ${age} ;;
  }
  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
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
  }

measure: newuser_days {
  type: number
# sql: diff_days(${users.created_date},now());;
  sql:DATE_DIFF(${created_date}, CURRENT_DATE, DAY) ;;
}

  measure: new_users_last_year{
    type: count
   # sql: ${created_date};;
    filters: [created_date: "9 months ago"]
  }

measure: is_new_user {
   type:yesno
   sql:${newuser_days}<=365;;
 }


  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, events.count, order_items.count]
  }
}
