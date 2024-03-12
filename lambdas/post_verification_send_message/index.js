import { SESClient, SendEmailCommand } from "@aws-sdk/client-ses";
const ses = new SESClient({ region: "us-east-2" });

export const handler = async (event) => {
  try {
    // Identify why this function was invoked
    if ("custom:created_by" in event.request.userAttributes) {
      let body = `Your Research Gateway account username is ${event.userName}`;
      await sendEmail(event.request.userAttributes.email, body);
    }
    // Return to Amazon Cognito
    return event;
  } catch (error) {
    console.error("Error:", error);
    // Return to Amazon Cognito with error
    return event;
  }
};

async function sendEmail(to, body) {
  const eParams = {
    Destination: {
      ToAddresses: [to],
    },
    Message: {
      Body: {
        Text: {
          Data: body,
        },
      },
      Subject: {
        Data: "Research Gateway account verification successful",
      },
    },
    // Replace source_email with your SES validated email address
    Source: "rlc.support@relevancelab.com",
  };

  try {
    const command = new SendEmailCommand(eParams);
    const response = await ses.send(command);
    console.log("Email sent:", response);
  } catch (error) {
    console.error("Error sending email:", error);
  }
}
