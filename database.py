import pymysql
import pymysql.cursors

def get_db():
    return pymysql.connect(
        host='localhost',
        user='root',
        password='your_password_here',
        database='job_tracker',
        cursorclass=pymysql.cursors.DictCursor
    )