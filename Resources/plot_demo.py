''' Demo of Python-Postgres Connection: '''

import matplotlib.pyplot as plt
import psycopg2


def get_data():
    ''' Demo of retrieving data from a database, then plotting it in Python:'''

    # Set up a connection to communicate with the database:
    conn = psycopg2.connect(database='postgres', user='postgres')
    cur = conn.cursor()

    # Define our query:  (normally string substitution here ...)
    sql = """
            SELECT 
                horsepower,
                mpg
            FROM 
                cars
            WHERE 
                mpg <> 0
            AND 
                horsepower <> 0
            ORDER BY 
                horsepower;
            """

    # Execute query, get the results:
    cur.execute(sql)
    result = cur.fetchall()

    # Close down the connection - not needed anymore.
    cur.close()
    conn.close()

    # Result will be a tuple for each car, of (horsepower, mpg).
    # We want to convert these into two arrays to plot in matplotlib:
    x = [item[0] for item in result]
    y = [item[1] for item in result]

    return x, y


def plot_data(x, y):
    # Adjust plot colors - just to make it look a little nicer:
    colors = [item for item in y]

    # Plot the data:
    plt.scatter(x, y, c=colors)
    plt.title("MPG vs Horsepower")
    plt.ylabel("Miles Per Gallon")
    plt.xlabel("Horsepower")
    plt.grid()
    plt.show()

    # Optional:  Save the plot:
    # plt.savefig("demo_plot.png")


if __name__ == '__main__':
    xvals, yvals = get_data()
    plot_data(xvals, yvals)
