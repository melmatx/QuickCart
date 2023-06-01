# QuickCart

Simple E-commerce web app made with [Flutter](https://flutter.dev/), using [Firebase](https://firebase.google.com/) and [Stripe](https://stripe.com/) as Backend.

<img width="200" alt="Screenshot 2023-05-29 at 7 24 53 PM" src="https://github.com/melmatx/QuickCart/assets/87235413/71d75c69-c89b-4709-bf18-85cbc3a09ae5">


## Try the app now

[QuickCart for Web](https://quickcart-web.vercel.app/) (Recommended)

[QuickCart for Android](https://github.com/melmatx/QuickCart/releases/)

## Getting Started

1. Make sure to install Flutter first:

[Download Flutter here](https://docs.flutter.dev/get-started/install)

2. Clone/download the files to your computer:

`git clone https://github.com/melmatx/quickcart.git`

3. Go to the directory of this project on your local computer:

`cd quickcart`

4. Get all dependencies for this project:

`flutter pub get`

5. Run the flutter app. Make sure you have your Android or iOS Simulator open:

`flutter run`

## To populate products in the app:

1. Create a new project in Firebase.
2. Connect the app to this project using the Flutter option in Firebase.
3. Create a new collection named **categories** in your Firestore Database.
4. Add a new document in this collection with these fields (for each categories):

- Document ID: Auto-ID

| Field    | Type    | Value                     |
| -------- | ------- | ------------------------- |
| id       | string  | any unique id             |
| image    | string  | category image link (Ex: https://www.lg.com/ph/images/monitors/md07562694/D1.jpg) |
| name     | string  | category name             |

5. Now, make another collection inside this document named **products**.
6. Add a new document (for each products) with this fields:

- Document ID: Auto-ID

| Field       | Type    | Value                     |
| ----------- | ------- | ------------------------- |
| id          | string  | any unique id             |
| image       | string  | product image link        |
| name        | string  | product name              |
| description | string  | product description       |
| price       | number  | product price             |

**Done! The products you inserted should now appear in the app.**
