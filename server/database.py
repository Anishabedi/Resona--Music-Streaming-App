from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
DATABASE_URL ='postgresql://postgres:root@localhost:5432/resona'

engine = create_engine(DATABASE_URL)                         # to connect database
SessionLocal = sessionmaker(autocommit = False, autoflush=False ,bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# hme database se connect krne ke liye session cahiye hoga to
# session = sessionlocal() krenge or session local vo hai  jis
# databse se hm connect hai or vo connect krne ke liye hm
# engine = create_engine(Database ka url aayega)

# 1. engine        →  "Database ka address pata hai mujhe"
# 2. SessionLocal  →  "Engine ka address use karke
#                       sessions banane ki factory"
# 3. session       →  "Actually kaam karne wala connection"

