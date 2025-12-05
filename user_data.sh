#!/bin/bash

# Set your name here
YOUR_NAME="Mohamed Aboelseoud"  # Change this to your name

# Update system
sudo apt update -y

# Install Apache (httpd)
sudo apt install -y apache2

# Start and enable Apache
sudo systemctl start apache2
sudo systemctl enable apache2
    
# Get private IP address
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Create custom index.html
sudo cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apache Server - ${YOUR_NAME}</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            max-width: 1000px;
            width: 100%;
        }
        
        .header {
            background: linear-gradient(135deg, #2c3e50 0%, #4a6491 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 2.8em;
            margin-bottom: 10px;
        }
        
        .header .subtitle {
            font-size: 1.2em;
            opacity: 0.9;
            margin-bottom: 20px;
        }
        
        .logo {
            font-size: 60px;
            margin-bottom: 20px;
        }
        
        .content {
            padding: 40px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .info-card {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            border-left: 5px solid;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        
        .info-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .info-card.server { border-color: #3498db; }
        .info-card.network { border-color: #2ecc71; }
        .info-card.system { border-color: #e74c3c; }
        .info-card.deployment { border-color: #f39c12; }
        
        .info-card h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 1.4em;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .info-card p {
            color: #34495e;
            line-height: 1.6;
            margin-bottom: 10px;
        }
        
        .highlight {
            background: #fff3cd;
            padding: 8px 15px;
            border-radius: 8px;
            display: inline-block;
            font-weight: bold;
            color: #856404;
        }
        
        .footer {
            text-align: center;
            padding: 30px;
            background: #f8f9fa;
            border-top: 1px solid #e9ecef;
            color: #6c757d;
        }
        
        .tech-stack {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        
        .tech-item {
            background: white;
            padding: 10px 20px;
            border-radius: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            font-weight: bold;
            color: #2c3e50;
        }
        
        @media (max-width: 768px) {
            .header h1 {
                font-size: 2em;
            }
            
            .content {
                padding: 20px;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">🚀</div>
            <h1>Welcome to My Apache Server</h1>
            <div class="subtitle">Deployed with Terraform & Jenkins</div>
            <div style="margin-top: 20px; font-size: 1.5em; color: #f1c40f;">
                Hello, I'm <span style="color: #fff; font-weight: bold;">${YOUR_NAME}</span>!
            </div>
        </div>
        
        <div class="content">
            <div class="info-grid">
                <div class="info-card server">
                    <h3><i class="fas fa-server"></i> Server Information</h3>
                    <p><strong>Instance ID:</strong> <span class="highlight">${INSTANCE_ID}</span></p>
                    <p><strong>Private IP:</strong> <span class="highlight">${PRIVATE_IP}</span></p>
                    <p><strong>Public IP:</strong> <span class="highlight">${PUBLIC_IP}</span></p>
                    <p><strong>Availability Zone:</strong> ${AVAILABILITY_ZONE}</p>
                </div>
                
                <div class="info-card network">
                    <h3><i class="fas fa-network-wired"></i> Network Details</h3>
                    <p><strong>HTTP Port:</strong> <span class="highlight">80 (Open)</span></p>
                    <p><strong>HTTPS Port:</strong> <span class="highlight">443 (Open)</span></p>
                    <p><strong>SSH Port:</strong> <span class="highlight">22 (Open)</span></p>
                    <p><strong>Access URL:</strong> http://${PUBLIC_IP}</p>
                </div>
                
                <div class="info-card system">
                    <h3><i class="fas fa-cogs"></i> System Status</h3>
                    <p><strong>Apache Status:</strong> <span class="highlight" style="background: #d4edda; color: #155724;">Running</span></p>
                    <p><strong>Uptime:</strong> $(uptime -p)</p>
                    <p><strong>Memory Usage:</strong> $(free -h | awk 'NR==2{print $3"/"$2}')</p>
                    <p><strong>Disk Usage:</strong> $(df -h / | awk 'NR==2{print $3"/"$2 " ("$5")"}')</p>
                </div>
                
                <div class="info-card deployment">
                    <h3><i class="fas fa-rocket"></i> Deployment Info</h3>
                    <p><strong>Deployed By:</strong> Jenkins Pipeline</p>
                    <p><strong>Infrastructure as Code:</strong> Terraform</p>
                    <p><strong>Deployment Time:</strong> $(date)</p>
                    <p><strong>Instance Type:</strong> t2.micro</p>
                </div>
            </div>
            
            <div style="text-align: center; margin: 40px 0;">
                <h2 style="color: #2c3e50; margin-bottom: 20px;">🛠️ Technology Stack</h2>
                <div class="tech-stack">
                    <div class="tech-item">AWS EC2</div>
                    <div class="tech-item">Apache HTTPD</div>
                    <div class="tech-item">Terraform</div>
                    <div class="tech-item">Jenkins CI/CD</div>
                    <div class="tech-item">Amazon Linux 2</div>
                    <div class="tech-item">Bash Scripting</div>
                </div>
            </div>
        </div>
        
        <div class="footer">
            <p>This infrastructure was deployed automatically using Infrastructure as Code principles</p>
            <p>Last updated: $(date)</p>
            <p style="margin-top: 15px; font-size: 0.9em;">
                <i class="fas fa-sync-alt"></i> Page auto-refreshes every 60 seconds
            </p>
        </div>
    </div>
    
    <script>
        // Auto-refresh page every 60 seconds
        setTimeout(function() {
            location.reload();
        }, 60000);
        
        // Display current time
        function updateTime() {
            const now = new Date();
            document.getElementById('current-time').textContent = now.toLocaleString();
        }
        
        setInterval(updateTime, 1000);
        updateTime();
    </script>
</body>
</html>
EOF

# Set proper permissions
sudo chmod 644 /var/www/html/index.html

# Create a health check endpoint
sudo cat > /var/www/html/health.html << EOF
<!DOCTYPE html>
<html>
<head><title>Health Check</title></head>
<body>
    <h1 style="color: green;">✅ Healthy</h1>
    <p>Apache web server is running correctly</p>
    <p>Server Time: $(date)</p>
    <p>Private IP: ${PRIVATE_IP}</p>
    <p>Public IP: ${PUBLIC_IP}</p>
</body>
</html>
EOF

# Restart Apache to apply changes
sudo systemctl restart apache2

# Enable Apache to start on boot
sudo systemctl enable apache2

# Test Apache
if systemctl is-active --quiet apache2; then
    echo "✅ Apache is running successfully"
    echo "🌐 Website is accessible at: http://${PUBLIC_IP}"
    echo "👋 Welcome message from: ${YOUR_NAME}"
    echo "🔒 Private IP displayed: ${PRIVATE_IP}"
else
    echo "❌ Apache failed to start"
    exit 1
fi

echo "🎉 Deployment completed successfully!"