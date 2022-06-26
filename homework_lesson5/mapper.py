#!/usr/bin/env python
"""CSV structure:
VendorID,
tpep_pickup_datetime,
tpep_dropoff_datetime,
passenger_count,
trip_distance,
RatecodeID,
store_and_fwd_flag,
PULocationID,
DOLocationID,
payment_type,
fare_amount,
extra,
mta_tax,
tip_amount,
tolls_amount,
improvement_surcharge,
total_amount,
congestion_surcharge
"""

"""mapper.py"""

import sys


def perform_map():
    for line in sys.stdin:
        line = line.strip()
        elements = line.split(',')

        #A numeric code signifying how the passenger paid for the trip.
        # 1= Credit card; 2= Cash; 3= No charge; 4= Dispute; 5= Unknown; 6= Voided trip.
        payment_type = 'Unknown'
        if elements[9] == '1':
            payment_type = 'Credit card'
        if elements[9] == '2':
            payment_type = 'Cash'
        if elements[9] == '3':
            payment_type = 'No charge'
        if elements[9] == '4':
            payment_type = 'Dispute'
        if elements[9] == '5':
            payment_type = 'Unknown'
        if elements[9] == '6':
            payment_type = 'Voided trip'

        month = elements[1][:7]
        tips = elements[13]
        #clean the data
        if month[:4] == '2020':
            print('%s\t%s\t%s' % (payment_type, month, tips))


if __name__ == '__main__':
    perform_map()
