#!/usr/bin/env python
"""reducer.py"""

import sys


def perform_reduce():
    #this dictionary will include Key: paymentType_month, Value: [tips]
    month_tips = {}

    # Partitioner
    for line in sys.stdin:
        #line = line.strip()
        payment_type, month, tips = line.split('\t')
        try:
            tips = int(tips)
        except ValueError:
            continue
        key = payment_type + ',' + month
        if key in month_tips:
            month_tips[key].append(tips)
        else:
            month_tips[key] = []
            month_tips[key].append(tips)

    # Reducer
    print('Payment type,Month,Tips average amount\n')
    for key in month_tips.keys():
        month_average = sum(month_tips[key]) * 1.0 / len(month_tips[key])
        print('%s,%s\n' % (key, month_average))


if __name__ == '__main__':
    perform_reduce()