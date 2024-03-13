import functions_framework
import firebase_admin
from firebase_admin import firestore

firebase_admin.initialize_app()

@functions_framework.http
def overload(request):
  client = firestore.client()

  for x in range(4000):
    client.collection("changes").document(f"doc_{x}").set({"timestamp": firestore.firestore.SERVER_TIMESTAMP})

  for x in range(4000):
    client.collection("changes").document(f"doc_{x}").delete()

  return "OK"
