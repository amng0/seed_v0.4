//
//  Privacy Policy.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 2/2/24.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HeaderView()
                IntroductionSection()
                InformationCollectionSection()
                ProcessingInformationSection()
                SharingInformationSection()
                DataRetentionSection()
                MinorInformationSection()
                PrivacyRightsSection()
                DoNotTrackSection()
                USPrivacyRights_NoticeUpdates_ReviewUpdateDeleteInfoSection()
            }
            .padding()
        }
    }
}

struct HeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Privacy Policy")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Text("Last updated: February 2nd, 2024")
                .font(.headline)
                .padding(.bottom, 10)
        }
    }
}

// Introduction Section
struct IntroductionSection: View {
    var body: some View {
        Group {
            SectionTitle("Introduction")
            Text("This privacy notice for **Nuclear Design | Lifestyle Architecture** (\"we\", \"us\", \"our\") outlines how and why we may collect, store, use, and/or share (\"process\") your information when you use our services (\"Services\"), including when you download and use our mobile application (Seed), or any other application of ours that links to this privacy notice, and engage with us in other related ways, including any sales, marketing, or events.")
                .padding(.bottom, 20)
        }
    }
}

struct InformationCollectionSection: View {
    var body: some View {
        Group {
            SectionTitle("1. What Information Do We Collect?")
            Text("Personal Information You Disclose to Us:")
            BulletPoint("Names, email addresses, usernames, passwords, and other details as part of our service interactions.")
            
            Text("Application Data:")
            BulletPoint("If you use our applications, we may collect device and application usage details, subject to your consent.")
                .padding(.bottom, 20)
        }
    }
}

// Processing Information Section
struct ProcessingInformationSection: View {
    var body: some View {
        Group {
            SectionTitle("2. How Do We Process Your Information?")
            Text("We process your information to deliver and improve our Services, manage user accounts, communicate with you, ensure security, comply with laws, and with your consent for other purposes.")
        }
        .padding(.bottom, 10)
    }
}

// Sharing Information Section
struct SharingInformationSection: View {
    var body: some View {
        Group {
            SectionTitle("3. When and With Whom Do We Share Your Personal Information?")
            Text("We may share your information in specific situations with third parties, detailed within this section.")
        }
        .padding(.bottom, 10)
    }
}

// Data Retention Section
struct DataRetentionSection: View {
    var body: some View {
        Group {
            SectionTitle("4. How Long Do We Keep Your Information?")
            Text("We retain your personal information as long as necessary for the purposes outlined in this notice, unless a longer retention period is required or permitted by law.")
        }
        .padding(.bottom, 10)
    }
}

// Minor Information Section
struct MinorInformationSection: View {
    var body: some View {
        Group {
            SectionTitle("5. Do We Collect Information From Minors?")
            Text("We do not knowingly collect data from or market to children under 18 years of age.")
        }
        .padding(.bottom, 10)
    }
}

// Privacy Rights Section
struct PrivacyRightsSection: View {
    var body: some View {
        Group {
            SectionTitle("6. What Are Your Privacy Rights?")
            Text("You have certain rights regarding the personal information we hold about you, which vary depending on your location.")
        }
        .padding(.bottom, 10)
    }
}

// Do Not Track Section
struct DoNotTrackSection: View {
    var body: some View {
        Group {
            SectionTitle("7. Controls for Do-Not-Track Features")
            Text("We currently do not respond to Do-Not-Track signals due to a lack of industry standard.")
        }
        .padding(.bottom, 10)
    }
}

// U.S. Privacy Rights Section, Notice Updates Section, and Review, Update, or Delete Information Section

struct USPrivacyRights_NoticeUpdates_ReviewUpdateDeleteInfoSection: View {
    var body: some View {
        Group {
            SectionTitle("8. Do United States Residents Have Specific Privacy Rights?")
            Text("Specific rights are granted to residents of certain states, detailed within this section.")
            SectionTitle("9. Do We Make Updates to This Notice?")
            Text("We may update this notice to stay compliant with relevant laws.")
            SectionTitle("10. How Can You Review, Update, or Delete the Data We Collect From You?")
            Text("You may request to review, update, or delete your personal information through a data subject access request. Contact nucleardesign1@gmail.com to begin the process.")
            Text("This privacy policy was created using Termly's Privacy Policy Generator.")
        }
        .padding(.bottom, 10)
    }
}


//struct PrivacyPolicyView_Previews: PreviewProvider {
//    static var previews: some View {
//        PrivacyPolicyView()
//    }
//}
