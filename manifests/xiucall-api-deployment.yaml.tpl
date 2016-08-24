apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: xiucall-api
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: xiucall-api
    spec:
      containers:
      - name: xiucal-api
        image: ## Image is dynamically set by `make set-images` as part of dev deployment ##
        imagePullPolicy: Always
        env:
        - name: XIUCALL_DB_HOST
          value: xiucall-cluster-mysql
        - name: XIUCALL_DB_NAME
          value: nbb
        - name: XIUCALL_DB_USER
          value: root
        - name: XIUCALL_DB_PORT
          value: "3306"
        - name: XIUCALL_DB_PWD
          valueFrom:
            secretKeyRef:
              name: mysql-pass
              key: password.txt
        - name: XIUCALL_AUTH_KEY
          valueFrom:
            secretKeyRef:
              name: xiucall-auth-key
              key: auth-key.txt
        ports:
        - containerPort: 80
        volumeMounts:
        - name: xiucall-uploads-storage
          mountPath: /var/www/html/Uploads
      imagePullSecrets:
      - name: xiucall-registry-key
      volumes:
        - name: xiucall-uploads-storage
          persistentVolumeClaim:
            claimName: xiucall-uploads-pvc
              
