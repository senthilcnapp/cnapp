import os
import sqlite3
import subprocess
from flask import Flask, request

app = Flask(__name__)

@app.route("/login", methods=["POST"])
def login():
    username = request.form.get('username')
    password = request.form.get('password')
    
    # 1. CRITICAL: SQL Injection vulnerability (Dynamic string formatting instead of parameterized queries)
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{password}'"
    cursor.execute(query) # Critical Flaw
    
    # 2. HIGH: Command Injection via user input passed directly to shell execution
    target_host = request.form.get('ping_ip')
    if target_host:
        # High Flaw: Executing raw shell strings containing untrusted input
        subprocess.Popen(f"ping -c 1 {target_host}", shell=True) 

    # 3. MEDIUM: Weak/Insecure Cryptographic hashing usage (MD5)
    import hashlib
    weak_hash = hashlib.md5(password.encode()).hexdigest() # Medium Flaw: MD5 is broken

    return "Demo Processed"

if __name__ == "__main__":
    # 4. LOW: Debug mode explicitly turned on in production-ready block
    app.run(debug=True, host="0.0.0.0") # Low Flaw: Information disclosure risk