Below is the **updated PRD** for “seefood,” now reflecting the use of **OpenAI’s `gpt-4o-mini`** model for food identification and calorie analysis. The key changes are in the **AI Analysis** section and the **Data Models** and **API Contracts** sections, where we outline how to call the LLM API and what data structure it returns.

---

## 1. Product Overview

### 1.1 Purpose  
The goal of **seefood** is to provide users with a fast and accurate way to identify foods and their approximate calorie content from a photo. Users can then track their daily, weekly, and monthly calorie intake in a simple calendar view.

### 1.2 Objectives & Success Criteria
- **Objective 1**: Accurately detect and label foods from images at least 80% of the time (initial MVP).  
- **Objective 2**: Provide calorie (and optional macro) estimates for each detected food item within 10–20% margin of actual values.  
- **Objective 3**: Enable easy logging of meals into a calendar or timeline, so users can view total daily calorie intake and meal breakdown.  

**Key metrics**:
- Accuracy/recall of AI-based food detection.  
- User engagement: Daily/Weekly Active Users (DAU/WAU).  
- Retention: % of users logging daily for more than 7 days.  
- Time-to-result: Average time from photo capture to AI result (<2 seconds on stable network).

### 1.3 Target Users
- Health-conscious individuals tracking calories daily.  
- Fitness enthusiasts needing accurate meal logging.  
- Casual users curious about their meals’ nutritional content.

### 1.4 Product Scope
- **In Scope**: Photo-based AI detection of foods, approximate calorie count, logging meals to a daily calendar.  
- **Out of Scope**: Detailed micronutrient breakdown (beyond MVP), advanced portion measurement, robust meal planning with recommended diets.

---

Below are **updated sections** of the PRD—specifically **Features** and **Requirements**—to reflect the new user flow (storyline) on the home page, the calendar, and how the user takes/selects an image, analyzes it, and sees results in a sheet. 

---

## 2. Features

1. **Home Page**  
   - Displays the app name at the top.  
   - Shows a **calendar** in the middle of the screen, indicating each day of the current month.  
   - Has two **icon buttons** at the bottom for “Take Picture” (camera icon) and “Select from Library” (photo library icon).  

2. **Food Image Capture & Analysis Flow**  
   - When the user taps on one of the icon buttons (camera or library), they are taken to the appropriate interface.  
   - After the user chooses or takes an image, the app displays an **“Analyze”** button.  
   - Tapping “Analyze” triggers the AI detection call to OpenAI’s `gpt-4o-mini` API.  

3. **Result Sheet Display**  
   - Once the analysis is returned from the API, a **sheet** (modal) slides up.  
   - This sheet contains the following details in a nicely formatted layout:  
     - **Title** of the food item.  
     - **Description** (e.g., short text describing the food image).  
     - **Ingredients** (with calories per gram, total grams, and total calories).  
     - **Total Calories**.  
     - **Health Score**.  
   - The user can dismiss (close) this sheet to return to the home page.  

4. **Calendar & Logged Foods**  
   - The home page’s calendar automatically updates the **current date** (today) cell to display an **item** representing the newly analyzed food.  
   - When the user taps on this calendar entry, it opens a detailed view (either another sheet or a new screen) showing the full analysis result.  

5. **Edit & Confirm Food Details**  
   - (Optional MVP Feature) If desired, users can edit the LLM’s returned data (e.g., change ingredient amounts or remove an ingredient).  
   - Any edits recalculate the total calories in real time.  
   - The final data is saved to the user’s daily log.  

6. **Progress Dashboard / Summary**  
   - Displays aggregated daily/weekly/monthly intake.  
   - (Implementation details unchanged—still part of the future or extended features.)

---

## 3. Requirements for Each Feature

### 3.1 Home Page
- **Functional**  
  1. At launch, the app displays a home page with:
     - **App Name** at the top (e.g., “seefood”).  
     - A **calendar** in the center showing the current month.  
     - Two **icon buttons** at the bottom for “Take Picture” and “Select from Library.”  
  2. Tapping on the calendar days should highlight the selected day.  
  3. Tapping on any food item displayed in a day cell should open a detailed view (sheet or new screen) of that food log.  

- **Non-Functional**  
  1. The home page should load in under 1 second.  
  2. The calendar UI should be smooth and responsive to month/day transitions.  

- **Dependencies**  
  - Calendar UI component (native or third-party library).  
  - Access to device camera and photo library.  

- **Acceptance Criteria**  
  - On app launch, user sees the name of the app, the calendar in the middle, and two icon buttons at bottom.  
  - Days with no logged foods show no additional content.  
  - Days with a logged food show the item name or a relevant icon in that day’s cell.

### 3.2 Food Image Capture & Analysis Flow
- **Functional**  
  1. When the user taps the **camera icon**, open the device’s camera to capture an image.  
  2. When the user taps the **library icon**, open the device’s photo picker.  
  3. After selecting or taking a picture, show a screen with an **“Analyze”** button.  
  4. On tapping “Analyze,” the app calls the LLM endpoint (OpenAI `gpt-4o-mini`), passing the base64-encoded image.  

- **Non-Functional**  
  1. Camera and library access should adhere to OS permission requests.  
  2. The analyze request → response round-trip should typically be <2 seconds.  

- **Dependencies**  
  - Camera APIs (`AVFoundation`, `CameraX`, etc.).  
  - Photo library picker.  
  - OpenAI LLM API.  

- **Acceptance Criteria**  
  - User sees an “Analyze” button once an image is available.  
  - Clicking “Analyze” leads to a loading state, then proceeds to show the result sheet upon success.

### 3.3 Result Sheet Display
- **Functional**  
  1. A **sheet** (modal) should slide up over the current screen once the analysis data is ready.  
  2. The sheet should display:
     - **Title** (e.g., “Cheeseburger”).  
     - **Description** (e.g., “A delicious-looking cheeseburger…”).  
     - **List of Ingredients** (title, calories/gram, total grams, total calories).  
     - **Total Calories**.  
     - **Health Score**.  
  3. The user can **dismiss** the sheet to return to the home page.  

- **Non-Functional**  
  1. The sheet should appear smoothly (animation under 300ms).  
  2. The UI must handle different screen sizes (responsive design).  

- **Dependencies**  
  - A modal or bottom sheet UI component (iOS UIKit/SwiftUI, Android BottomSheet, or cross-platform alternative).  

- **Acceptance Criteria**  
  - The sheet has the correct styling (title, description, ingredient list, etc.).  
  - Dismissing the sheet returns the user to the home page and updates the calendar for today’s date with the new food item.

### 3.4 Calendar & Logged Foods
- **Functional**  
  1. Once the user dismisses the result sheet, the analyzed food is **logged** for today’s date.  
  2. The home page calendar’s **today cell** should now display an item representing the analyzed food (e.g., the `title`).  
  3. Tapping on that calendar item should open a detail view/sheet with the same data.  

- **Non-Functional**  
  1. Calendar updates must appear immediately upon returning to the home page.  
  2. The detail view should match the data from the LLM (or any user edits).  

- **Dependencies**  
  - Local or server database for storing meal logs.  
  - Calendar component that can display custom items.  

- **Acceptance Criteria**  
  - The day cell for “today” shows the newly analyzed food’s title or icon.  
  - Tapping it reopens a detail page with the food’s name, ingredients, etc.

### 3.5 Edit & Confirm Food Details *(Optional in MVP)*
- **Functional**  
  1. If implemented, users can modify the LLM-provided info (ingredients, grams, etc.) before finalizing.  
  2. The total calorie count updates in real time.  
  3. Saving final details logs them to the daily calendar.  

- **Non-Functional**  
  1. Changes reflect seamlessly in the UI.  
  2. Minimal performance overhead for real-time calculation.  

- **Dependencies**  
  - Possibly a local state manager to handle partial edits.  

- **Acceptance Criteria**  
  - Users can correct any incorrect ingredient info.  
  - The final data is stored/updated in the user’s meal log.

### 3.6 Progress Dashboard / Summary
*(Unchanged in general scope—still includes daily/weekly/monthly summaries. May or may not be in MVP.)*

---

**End of Updated Features & Requirements**

#### Sample cURL to LLM
Example request to the LLM (for reference in developer documentation):
```bash
curl https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
  "model": "gpt-4o-mini",
  "messages": [
    {
      "role": "user",
      "content": [
        {
          "type": "image_url",
          "image_url": {
            "url": "data:image/png;base64,<base64EncodedImageHere>"
          }
        }
      ]
    },
    {
      "role": "assistant",
      "content": [
        {
          "type": "text",
          "text": "..."
        }
      ]
    }
  ],
  "response_format": {
    "type": "json_schema",
    "json_schema": {
      "name": "food_analyzer",
      "strict": true,
      "schema": {
        "type": "object",
        "properties": {
          "title": {
            "type": "string",
            "description": "The title of the food item"
          },
          "image_description": {
            "type": "string",
            "description": "Description of the image of the food item"
          },
          "ingredients": {
            "type": "array",
            "description": "List of ingredients contained in the food item.",
            "items": {
              "type": "object",
              "properties": {
                "title": {
                  "type": "string",
                  "description": "Name of the ingredient"
                },
                "calories_per_gram": {
                  "type": "number",
                  "description": "Calories contained in one gram of the ingredient"
                },
                "total_gram": {
                  "type": "number",
                  "description": "Total grams of the ingredient present in the food item"
                },
                "total_calories": {
                  "type": "number",
                  "description": "Total calories contributed by the ingredient"
                }
              },
              "required": [
                "title",
                "calories_per_gram",
                "total_gram",
                "total_calories"
              ],
              "additionalProperties": false
            }
          },
          "total_calories": {
            "type": "number",
            "description": "Total calories of the food item"
          },
          "health_score": {
            "type": "number",
            "description": "Health score based on the ingredients and their quantities"
          }
        },
        "required": [
          "title",
          "image_description",
          "ingredients",
          "total_calories",
          "health_score"
        ],
        "additionalProperties": false
      }
    }
  },
  "temperature": 1,
  "max_completion_tokens": 2048,
  "top_p": 1,
  "frequency_penalty": 0,
  "presence_penalty": 0
}'
```

**Example Response**:
```json
{
  "title": "Cheeseburger",
  "image_description": "A delicious-looking cheeseburger featuring a sesame seed bun, fresh lettuce, pickles, ketchup, and melted cheese over a beef patty, with a side of fries in the background.",
  "ingredients": [
    {
      "title": "Sesame seed bun",
      "calories_per_gram": 2.5,
      "total_gram": 60,
      "total_calories": 150
    },
    {
      "title": "Beef patty",
      "calories_per_gram": 2.5,
      "total_gram": 100,
      "total_calories": 250
    },
    {
      "title": "Cheddar cheese",
      "calories_per_gram": 4,
      "total_gram": 30,
      "total_calories": 120
    },
    {
      "title": "Ketchup",
      "calories_per_gram": 1,
      "total_gram": 20,
      "total_calories": 20
    },
    {
      "title": "Lettuce",
      "calories_per_gram": 0.15,
      "total_gram": 15,
      "total_calories": 2
    },
    {
      "title": "Pickles",
      "calories_per_gram": 0.5,
      "total_gram": 20,
      "total_calories": 10
    },
    {
      "title": "Onion",
      "calories_per_gram": 0.4,
      "total_gram": 15,
      "total_calories": 6
    }
  ],
  "total_calories": 558,
  "health_score": 5
}
```

### 3.3 Edit & Confirm Food Details
- **Functional**  
  1. Users can edit the LLM’s returned `title` or `ingredients`.  
  2. Users can add/remove ingredients if the LLM’s breakdown is incorrect.  
  3. Updating ingredient grams or removing an ingredient should automatically recalculate `total_calories`.  
  4. A “Save” button confirms changes and logs the meal.  
- **Non-Functional**  
  1. Changes must reflect immediately in the UI.  
  2. Validate user inputs (cannot have negative grams, etc.).  
- **Dependencies**  
  - Local state management to handle edits before server update.  
- **Acceptance Criteria**  
  - If user changes “Cheddar cheese” from 30g to 20g, `total_calories` is recalculated.  
  - Saving final data proceeds to meal logging.

### 3.4 Meal Logging & Calendar
- **Functional**  
  1. Once confirmed, log the meal (title, final ingredients, total_calories, health_score) to the user’s account on the selected date.  
  2. Show a calendar with daily total calories.  
  3. Tapping a date displays the logged meals.  
- **Non-Functional**  
  1. Calendar should load under 1 second.  
  2. Should handle scrolling to past/future months or weeks.  
- **Dependencies**  
  - A backend to store Meal records (see Data Models).  
  - Calendar UI components.  
- **Acceptance Criteria**  
  - Each day shows total calories.  
  - Tapping a date shows the meal breakdown.

### 3.5 Progress Dashboard / Summary
- **Functional**  
  1. Show daily/weekly/monthly calorie graphs or summaries.  
  2. Provide basic stats (average daily intake, highest day, etc.).  
- **Non-Functional**  
  1. Graphing library must handle dynamic data well.  
  2. Summaries update upon new meal logs.  
- **Dependencies**  
  - Charting library.  
- **Acceptance Criteria**  
  - Dashboard updates immediately when new meals are logged.

### 3.6 User Authentication & Profile
- **Functional**  
  1. Users can sign up/login.  
  2. Maintain session tokens (e.g., JWT).  
  3. Each meal log is tied to a unique user ID.  
- **Non-Functional**  
  1. Follow secure password storage and encryption.  
  2. Response times for login <1 second.  
- **Dependencies**  
  - Auth service (e.g., Firebase, Cognito, or custom).  
- **Acceptance Criteria**  
  - Auth tokens provided after successful login.  
  - Meal logs only visible to the authenticated user.

---

## 4. Data Models

### 4.1 AI Response Model (from `gpt-4o-mini`)
When we call the LLM, it returns a JSON adhering to the schema below:

```json
{
  "title": "string",
  "image_description": "string",
  "ingredients": [
    {
      "title": "string",
      "calories_per_gram": "number",
      "total_gram": "number",
      "total_calories": "number"
    }
    ...
  ],
  "total_calories": "number",
  "health_score": "number"
}
```

### 4.2 User
```json
{
  "userId": "string",
  "email": "string",
  "passwordHash": "string",
  "authProvider": "string",
  "createdAt": "Date",
  "updatedAt": "Date"
}
```

### 4.3 Meal
```json
{
  "mealId": "string",
  "userId": "string",
  "mealDate": "string (YYYY-MM-DD)",
  "title": "string",               // from AI or user edit
  "imageDescription": "string",    // optional storage
  "ingredients": [
    {
      "title": "string",
      "caloriesPerGram": "number",
      "totalGram": "number",
      "totalCalories": "number"
    }
    ...
  ],
  "totalCalories": "number",
  "healthScore": "number",
  "createdAt": "Date",
  "updatedAt": "Date"
}
```

---

## 5. API Contracts

> Note: You may have both a **direct call** to OpenAI’s API from the client or a **server-side wrapper** (recommended for security). Below is how the final data might be stored or retrieved via your own backend.

### 5.1 AI Food Detection (via `gpt-4o-mini`)
*(Client or server calls OpenAI directly—example cURL shown above. Not repeated here for brevity.)*

### 5.2 `POST /v1/meals`
- **Description**: Creates a new meal log (after user confirms AI data).  
- **Request**:  
  - **Headers**:  
    - `Content-Type: application/json`  
    - `Authorization: Bearer <token>`  
  - **Body**:
    ```json
    {
      "userId": "<USER_ID>",
      "mealDate": "YYYY-MM-DD",
      "title": "Cheeseburger",
      "imageDescription": "A delicious-looking cheeseburger...",
      "ingredients": [
        {
          "title": "Beef patty",
          "caloriesPerGram": 2.5,
          "totalGram": 100,
          "totalCalories": 250
        }
      ],
      "totalCalories": 558,
      "healthScore": 5
    }
    ```
- **Response (200)**:
  ```json
  {
    "mealId": "<MEAL_ID>",
    "status": "success"
  }
  ```
- **Error Response (4xx/5xx)**:
  ```json
  {
    "error": "description of the error"
  }
  ```

### 5.3 `GET /v1/meals?userId=<USER_ID>&date=<YYYY-MM-DD>`
- **Description**: Retrieves meal logs for a user on a specific date.  
- **Request**:  
  - **Headers**:  
    - `Authorization: Bearer <token>`
  - **Query Params**:  
    - `userId` (string)  
    - `date` (string, YYYY-MM-DD)  
- **Response (200)**:
  ```json
  {
    "meals": [
      {
        "mealId": "<MEAL_ID>",
        "mealDate": "YYYY-MM-DD",
        "title": "Cheeseburger",
        "imageDescription": "A delicious-looking cheeseburger...",
        "ingredients": [
          {
            "title": "Beef patty",
            "caloriesPerGram": 2.5,
            "totalGram": 100,
            "totalCalories": 250
          }
        ],
        "totalCalories": 558,
        "healthScore": 5
      }
    ]
  }
  ```
- **Error Response (4xx/5xx)**:
  ```json
  {
    "error": "description of the error"
  }
  ```

### 5.4 `GET /v1/meals/summary?userId=<USER_ID>&startDate=<YYYY-MM-DD>&endDate=<YYYY-MM-DD>`
- **Description**: Retrieves aggregated meal data (total calories, etc.) within a date range.  
- **Request**:  
  - **Headers**:
    - `Authorization: Bearer <token>`
  - **Query Params**:
    - `userId` (string)  
    - `startDate` (string, YYYY-MM-DD)  
    - `endDate` (string, YYYY-MM-DD)  
- **Response (200)**:
  ```json
  {
    "summary": [
      {
        "date": "YYYY-MM-DD",
        "totalCalories": 1200,
        "meals": [...],
        "healthScores": [...]
      }
      ...
    ]
  }
  ```
- **Error Response (4xx/5xx)**:
  ```json
  {
    "error": "description of the error"
  }
  ```

### 5.5 Authentication
*(Login, signup endpoints as needed—unchanged from earlier version.)*

---

## 6. Assumptions & Dependencies

1. **OpenAI LLM**: We assume stable connectivity to the `gpt-4o-mini` model with an API key.  
2. **Nutrition Data**: The LLM’s knowledge base or training set is sufficiently robust to handle common foods.  
3. **Security**: Direct calls to OpenAI from the client might expose API keys, so a server-side proxy is typically recommended.  
4. **Storage & Backend**: A backend service or cloud function is needed for meal logs, user data, etc.  
5. **Mobile Platforms**: iOS (14+) and Android (SDK 21+).  

---

## 7. Additional Considerations

- **Privacy**: All user data and images must be handled securely over HTTPS.  
- **Localization**: MVP is English-only. Future versions may handle multi-language.  
- **Future Enhancements**:  
  - Automatic portion estimation using bounding boxes (more advanced ML).  
  - Deeper integration with 3rd-party APIs to refine calorie estimates.

---

## 8. Summary

This updated PRD outlines an end-to-end approach for building **seefood**, incorporating **OpenAI’s `gpt-4o-mini`** to identify foods, provide a breakdown of ingredients, and calculate calorie totals. The newly specified **AI Analysis** flow uses a structured JSON schema to ensure predictable responses. By following these detailed requirements, data models, and API contracts, the engineering team can implement the system without ambiguity.

**End of Updated PRD**